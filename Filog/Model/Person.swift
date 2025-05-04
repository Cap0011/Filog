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
    let knownForDepartment: String?
    let name: String
    let profilePath: String?
    let knownFor: [KnownFor]?
    
    let birthday: String?
    let deathday: String?
    let biography: String?
    let placeOfBirth: String?
    
    let combinedCredits: CombinedCredits?
    
    let externalIds: Social?

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

struct CombinedCredits: Decodable {
    let cast: [Cast]
    let crew: [Crew]
    
    struct Cast: Decodable, Identifiable {
        let id: Int
        let character: String?
        let title: String?
        let releaseDate: String?
        let posterPath: String?
        let mediaType: String?
        
        var posterURL: URL? {
            guard let path = posterPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
        }
        
        var yearText: String {
            guard let date = releaseDate else { return "" }
            return String(date.prefix(4))
        }
    }

    struct Crew: Decodable, Identifiable, Hashable {
        let id: Int
        let department: String?
        let job: String?
        let title: String?
        let releaseDate: String?
        let posterPath: String?
        let mediaType: String?
        
        var posterURL: URL? {
            guard let path = posterPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
        }
        
        var yearText: String {
            guard let date = releaseDate else { return "" }
            return String(date.prefix(4))
        }
    }
}

struct Social: Decodable {
    let facebookId: String?
    let twitterId: String?
    let instagramId: String?
    
    var facebookURL: URL? {
        if let id = facebookId { return URL(string: "https://facebook.com/\(id)") }
        else { return nil }
    }
    
    var twitterURL: URL? {
        if let id = twitterId { return URL(string: "https://twitter.com/\(id)") }
        else { return nil }
    }
    
    var instagramURL: URL? {
        if let id = instagramId { return URL(string: "https://instagram.com/\(id)") }
        else { return nil }
    }
}

extension Person: Searchable {
    static func search(query: String) -> AnyPublisher<[Person], Never> {
        FilmService.shared.searchPeople(query: query)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

extension Person: DetailFetchable {
    static var detailPathComponent = "person"
    
    static var queryItems: [String : String]? = [
        "append_to_response": "combined_credits,external_ids"
    ]
}
