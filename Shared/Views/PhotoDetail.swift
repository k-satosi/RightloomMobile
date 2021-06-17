//
//  PhotoDetail.swift
//  Rightloom
//

import SwiftUI

struct PhotoDetail: View {
    var photo: Photo
    @State var image: UIImage? = nil
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
            }
        }.onAppear(perform: {
            let url = settings.serverURL + "/" + photo.path
            downloadImageAsync(url: URL(string: url)!) {image in
                self.image = image!
            }
        })
    }
}

struct PhotoDetail_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetail(photo: Photo.init())
    }
}
