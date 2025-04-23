//
//  PosterImage.swift
//  Filog
//
//  Created by Jiyoung Park on 4/19/25.
//

import CachedAsyncImage
import SwiftUI

struct PosterImage: View {
    let imageURL: URL?
    
    var body: some View {
        CachedAsyncImage(url: imageURL, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                default: Utils.placeholderColor
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .frame(width: 120)
        .cornerRadius(4)
        .shadow(radius: 4)
    }
}
