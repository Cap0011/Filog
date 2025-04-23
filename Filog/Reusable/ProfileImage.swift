//
//  ProfileImage.swift
//  Filog
//
//  Created by Jiyoung Park on 4/20/25.
//

import CachedAsyncImage
import SwiftUI

struct ProfileImage: View {
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
        .aspectRatio(contentMode: .fill)
        .frame(width: 104, height: 154)
    }
}
