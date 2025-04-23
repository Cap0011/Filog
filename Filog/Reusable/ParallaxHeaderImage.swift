//
//  ParallaxHeaderImage.swift
//  Filog
//
//  Created by Jiyoung Park on 4/19/25.
//

import CachedAsyncImage
import SwiftUI

struct ParallaxHeaderImage: View {
    let imageURL: URL?
    
    var body: some View {
        GeometryReader { geometry in
            CachedAsyncImage(url: imageURL, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                default: Utils.placeholderColor
                }
            }
            .aspectRatio(9/5, contentMode: .fill)
            .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
            .clipped()
            .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
        }.frame(height: UIScreen.main.bounds.size.width * 5 / 9)
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }
}
