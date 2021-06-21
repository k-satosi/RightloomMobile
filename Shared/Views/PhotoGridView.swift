//
//  PhotoGridView.swift
//  Rightloom
//

import SwiftUI

func uploadImage(token: String, paramName: String, fileName: String, image: UIImage, completion: @escaping (Error?)->Void) {
    let url = URL(string: "http://localhost/api/photos/")

    // generate boundary string using a unique per-app string
    let boundary = UUID().uuidString

    let session = URLSession.shared

    // Set the URLRequest to POST and to the specified URL
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"

    urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")

    // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
    // And the boundary is also set here
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    var data = Data()

    // Add the image data to the raw http request data
    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    data.append(image.jpegData(compressionQuality: 1)!)

    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    // Send a POST request to the URL, with the data we created earlier
    session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
        if error == nil {
            let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
            if let json = jsonData as? [String: Any] {
                print(json)
            }
        }
        DispatchQueue.main.async {
            completion(error)
        }
    }).resume()
}

func downloadImageAsync(url: URL, completion: @escaping (UIImage?) -> Void) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { (data, _, _) in
        var image: UIImage?
        if let imageData = data {
            image = UIImage(data: imageData)
        }
        DispatchQueue.main.async {
            completion(image)
        }
    }
    task.resume()
}

struct PhotoGridView: View {
    @State var photos = [Photo]()
    @State var images = [UIImage?]()
    
    @State var navigationViewIsActive = false
    @State var selectedPhoto: Photo? = nil
    
    @State var isShowPhotoLibrary = false
    @State var pickedImage = UIImage()

    @EnvironmentObject var authInfo: AuthInfo
    @EnvironmentObject var settings: Settings
    
    func fetchPhotos(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.addValue("Bearer " + authInfo.token, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                let _photos = try! JSONDecoder().decode([Photo].self, from: data)
                // dump(_photos)
                self.images.removeAll()
                self.photos.removeAll()
                for num in 0..<_photos.count {
                    let url = settings.serverURL + "/" + _photos[num].path
                    downloadImageAsync(url: URL(string: url)!) {image in
                        self.images.append(image)
                        self.photos.append(_photos[num])
                    }
                }
            }
        })
        task.resume()
    }
    
    var body: some View {
        VStack {
            VStack {
                if selectedPhoto != nil {
                    NavigationLink(
                        destination: PhotoDetail(photo: selectedPhoto!),
                        isActive: $navigationViewIsActive) {
                        EmptyView()
                    }
                }
            }.hidden()
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                    ForEach(0..<images.count, id: \.self) {num in
                        Button(action: {
                            selectedPhoto = photos[num]
                            navigationViewIsActive = true
                        }) {
                            Image(uiImage: images[num]!)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }.onAppear(perform: {
                let url = settings.serverURL + "/api/photos"
                fetchPhotos(urlString: url)
            })
        }
        .sheet(isPresented: $isShowPhotoLibrary, onDismiss: {
            // upload image
            uploadImage(token: authInfo.token, paramName: "file", fileName: "aaa.jpeg", image: self.pickedImage) { error in
                if error == nil {
                    let url = settings.serverURL + "/api/photos"
                    fetchPhotos(urlString: url)
                }
            }

        }, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage:  self.$pickedImage)
        })
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button(action: {
                    isShowPhotoLibrary = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                Spacer()
            }
        }
    }
}

struct PhotoGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView().environmentObject(AuthInfo())
            .environmentObject(Settings())
    }
}
