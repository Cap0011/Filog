//
//  FilmListEndpoint.swift
//  Filog
//
//  Created by Jiyoung Park on 3/28/25.
//

enum FilmListEndpoint: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case nowPlaying = "now_playing"
    case upcoming
    case popular
    case topRated = "top_rated"
    
    var text: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        }
    }
    
    var imageType: FilmCarouselView.ImageType {
        switch self {
        case .nowPlaying: return .largePoster
        case .upcoming: return .smallPoster
        default: return .backdrop
        }
    }
}
