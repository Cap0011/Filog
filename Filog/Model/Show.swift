//
//  Show.swift
//  Filog
//
//  Created by Jiyoung Park on 4/9/25.
//

import Combine
import Foundation

struct ShowResponse: Decodable {
    let results: [Show]
}

struct Show: Decodable, Identifiable {
    let id: Int
    let name: String?
    let posterPath: String?
    let firstAirDate: String?
    let lastAirDate: String?
    
    let adult: Bool?
    let backdropPath: String?
    let createdBy: [Person]?
    let genres: [Genre]?
    let networks: [Network]?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let overview: String?
    let seasons: [Season]?
    let tagline: String?
    let voteAverage: Double?
    
    let aggregateCredits: CreditResponse?
    let recommendations: ShowResponse?
    let similar: ShowResponse?
    let videos: VideoResponse?
    
    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w342\(path)")
    }
    
    var displayTitle: String {
        name ?? "N/A"
    }
    
    var displayFirstDate: String {
        guard let date = firstAirDate else { return "N/A" }
        return date.replacingOccurrences(of: "-", with: ".")
    }
    
    var displayLastDate: String {
        guard let date = lastAirDate else { return "N/A" }
        return date.replacingOccurrences(of: "-", with: ".")
    }
    
    var genresText: String {
        guard let genres = genres else { return "N/A" }
        return genres.map { $0.name }.joined(separator: ", ")
    }
    
    var year: String {
        guard let date = firstAirDate else { return "" }
        return String(date.prefix(4))
    }

    struct Genre: Decodable {
        let name: String
    }
    
    struct Network: Decodable {
        let id: Int
        let logoPath: String?
        let name: String?
        let originCountry: String?
        
        var logoURL: URL? {
            guard let path = logoPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
        }
    }
    
    struct Season: Decodable {
        let id: Int
        let airDate: String?
        let episodeCount: Int?
        let name: String?
        let overview: String?
        let posterPath: String?
        let seasonNumber: Int?
        let voteAverage: Double?
        
        var posterURL: URL? {
            guard let path = posterPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
        }
    }
    
    struct CreditResponse: Decodable {
        let cast: [Cast]?

        struct Cast: Decodable, Identifiable {
            let id: Int
            let name: String?
            let profilePath: String?
            let roles: [Role]?
            let totalEpisodeCount: Int?

            var profileURL: URL? {
                guard let path = profilePath else { return nil }
                return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
            }
            
            var characters: String {
                guard let roles = roles else { return "N/A" }
                return roles.compactMap { $0.character }.joined(separator: ", ")
            }
            
            struct Role: Decodable {
                let character: String?
            }
        }
    }
}

extension Show: Searchable {
    static func search(query: String) -> AnyPublisher<[Show], Never> {
        FilmService.shared.searchShows(query: query)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

extension Show: DetailFetchable {
    static var detailPathComponent = "tv"
    
    static var queryItems: [String : String]? = [
        "append_to_response": "videos,aggregate_credits,recommendations,similar"
    ]
}
