//
//  FilmData.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import Foundation
import Combine

struct FilmResponse: Decodable {
    let results: [FilmData]
}

struct FilmData: Decodable, Identifiable {
    let id: Int
    let adult: Bool?
    let backdropPath: String?
    let genres: [Genre]?
    let originalLanguage: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let tagline: String?
    let title: String?
    let voteAverage: Double?
    
    let credits: CreditResponse?
    let recommendations: FilmResponse?
    let similar: FilmResponse?
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
        title ?? "N/A"
    }
    
    var displayDate: String {
        guard let date = releaseDate else { return "N/A" }
        return date.replacingOccurrences(of: "-", with: ".")
    }
    
    var yearText: String {
        guard let date = releaseDate else { return "N/A" }
        return String(date.prefix(4))
    }
    
    var displayRuntime: String {
        guard let runtime = runtime, runtime > 0 else { return "N/A" }
        return "\(runtime / 60)h \(runtime % 60)m"
    }
    
    var genresText: String {
        guard let genres = genres else { return "N/A" }
        return genres.map { $0.name }.joined(separator: ", ")
    }

    struct CreditResponse: Decodable {
        let cast: [Cast]
        let crew: [Crew]
        
        var director: [Crew]? {
            crew.filter { $0.job?.lowercased() == "director" }
        }
        
        struct Cast: Decodable, Identifiable {
            let id: Int
            let name: String?
            let profilePath: String?
            let character: String?

            var profileURL: URL? {
                guard let path = profilePath else { return nil }
                return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
            }
        }
        
        struct Crew: Decodable, Identifiable {
            let id: Int
            let name: String?
            let profilePath: String?
            let job: String?

            var profileURL: URL? {
                guard let path = profilePath else { return nil }
                return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
            }
        }
    }
}

struct Genre: Decodable {
    let name: String
}

struct VideoResponse: Decodable {
    let results: [Video]
    
    var youtubeTrailers: [Video]? {
        results.filter { $0.youtubeURL != nil }
    }
    
    struct Video: Decodable, Identifiable {
        let id: String
        let name: String?
        let key: String?
        let site: String?
        
        var youtubeURL: URL? {
            guard site == "YouTube", let key = key else { return nil }
            return URL(string: "https://youtube.com/watch?v=\(key)")
        }
        
        var youtubeThumbnailURL: URL? {
            guard let key = key else { return nil }
            return URL(string: "https://img.youtube.com/vi/\(key)/0.jpg")
        }
    }
}

extension FilmData: Searchable {
    static func search(query: String) -> AnyPublisher<[FilmData], Never> {
        FilmService.shared.searchFilms(query: query)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

extension FilmData: DetailFetchable {
    static var detailPathComponent = "movie"
    
    static var queryItems: [String : String]? = [
        "append_to_response": "videos,credits,recommendations,similar"
    ]
}
