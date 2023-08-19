//
//  PosterImage.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-06.
//

import SwiftUI
import SDWebImageSwiftUI

struct PosterImage: View {
    
    var url: String
    var placeholder: Bool = true

    var body: some View {
        ZStack {
            WebImage(url: URL(string: url))
                .resizable()
                .placeholder(content: {
                    if placeholder {
                        Image(systemName: "photo")
                            .opacity(0.2)
                    }
                })
                .transition(.fade(duration: 0.5))
            Color.black.opacity(0.1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct PosterImage_Previews: PreviewProvider {
    static var previews: some View {
        PosterImage(url: "https://production.listennotes.com/podcasts/star-wars-7x7-the/856-the-academy-clone-wars-6-EXfkbp4Sz-l6QpC-2RDTH.600x315.jpg")
    }
}
