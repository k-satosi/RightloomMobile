//
//  PhotoGridView.swift
//  Rightloom
//

import SwiftUI

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
    }
}

struct PhotoGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView().environmentObject(AuthInfo())
    }
}
