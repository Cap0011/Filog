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
    case topRated = "top_rated"
    case popular
    
    var text: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
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
