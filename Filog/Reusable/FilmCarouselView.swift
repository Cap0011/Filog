//
//  FilmPosterCarouselView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI
import CachedAsyncImage

struct FilmCarouselView: View {
    enum ImageType {
        case smallPoster
        case largePoster
        case backdrop
        
        var width: CGFloat {
            switch self {
            case .smallPoster:
                return (Utils.screenWidth - 28) / 7 * 2
            case .largePoster:
                return (Utils.screenWidth - 32) / 5 * 2
            case .backdrop:
                return (Utils.screenWidth - 24) / 3 * 2
            }
        }
        
        var font: Font {
            switch self {
            case .largePoster:
                return .medium16
            default:
                return .regular14
            }
        }
        
        var horizontalSpacing: CGFloat {
            switch self {
            case .smallPoster:
                return 6
            default:
                return 8
            }
        }
        
        var alignment: Alignment {
            switch self {
            case .backdrop:
                return .leading
            default:
                return .center
            }
        }
        
        var aspectRatio: CGFloat {
            switch self {
            case .backdrop:
                return 270/152
            default:
                return 2/3
            }
        }
        
        func imageURL(film: FilmData) -> URL? {
            switch self {
            case .backdrop:
                return film.backdropURL
            default:
                return film.posterURL
            }
        }
    }
    
    let title: String
    let films: [FilmData]
    let imageType: ImageType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.semibold20)
                .frame(height: 28)
                .padding(.leading, 20)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: imageType.horizontalSpacing) {
                    ForEach(films) { film in
                        NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                            VStack(spacing: 4 + (imageType == .largePoster ? 4 : 0)) {
                                FilmImageView(url: imageType.imageURL(film: film), imageType: imageType)
                                
                                Text(film.displayTitle)
                                    .lineLimit(1)
                                    .font(imageType.font)
                                    .frame(width: imageType.width - 8, height: 20, alignment: imageType.alignment)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
        }
        .foregroundStyle(.primaryBlack)
    }
    
    struct FilmImageView: View {
        let url: URL?
        let imageType: ImageType
        
        var body: some View {
            CachedAsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                    default: Utils.placeholderColor
                }
            }
            .aspectRatio(imageType.aspectRatio, contentMode: .fit)
            .frame(width: imageType.width)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.12), radius: 4, x: 4, y: 4)
        }
    }
}
