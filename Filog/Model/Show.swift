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
    let name: String
    let posterPath: String?
    let firstAirDate: String?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
    
    var year: String {
        guard let date = firstAirDate else { return "" }
        return String(date.prefix(4))
    }
}

extension Show: Searchable {
    static func search(query: String) -> AnyPublisher<[Show], Never> {
        FilmService.shared.searchShows(query: query)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
