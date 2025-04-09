//
//  Person.swift
//  Filog
//
//  Created by Jiyoung Park on 4/8/25.
//

import Combine
import Foundation

struct PersonSearchResponse: Decodable {
    let results: [Person]
}

struct Person: Decodable, Identifiable {
    let id: Int
    let knownForDepartment: String
    let name: String
    let profilePath: String?
    let knownFor: [KnownFor]?

    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

struct KnownFor: Decodable {
    let title: String?
    let name: String?
    
    var displayTitle: String {
        title ?? name ?? "Unknown"
    }
}

extension Person: Searchable {
    static func search(query: String) -> AnyPublisher<[Person], Never> {
        FilmService.shared.searchPeople(query: query)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
