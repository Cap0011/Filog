//
//  YoutubeCarouselView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/16.
//

import SwiftUI
import CachedAsyncImage

struct YoutubeCarouselView: View {
    
    let videos: [FilmVideo]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(self.videos) { video in
                    if video.youtubeURL != nil {
                        Link(destination: video.youtubeURL!) {
                            YoutubeBackdropCard(thumbnailURL: video.youtubeThumbnailURL!, videoName: video.name)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct YoutubeBackdropCard: View {
    let thumbnailURL: URL
    let videoName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                CachedAsyncImage(url: thumbnailURL)  { image in
                    image
                        .resizable()
                } placeholder: {
                    Image("NoPosterBackdrop")
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fit)
                }
                .scaledToFill()
                .frame(width: 270, height: 150, alignment: .center)
                .clipped()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .shadow(radius: 4)
                
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.white)
                    .opacity(0.85)
            }
            
            Text(videoName)
                .multilineTextAlignment(.leading)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .truncationMode(.tail)
                .lineLimit(1)
        }
        .frame(width: 270)
    }
}
