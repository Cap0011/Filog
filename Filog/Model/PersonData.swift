//
//  PersonData.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/31.
//

import Foundation

struct PersonData: Decodable, Identifiable {
    let id: Int
    let birthday: String?
    let deathday: String?
    let name: String
    let biography: String
    let placeOfBirth: String?
    let profilePath: String?
    
    let movieCredits: Credit?
    
    let externalIds: Social?
    
    var profileURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w185\(profilePath ?? "")")!
    }
    
    var cast: [Cast]? {
        movieCredits?.cast
    }
    
    var crew: [Crew]? {
        movieCredits?.crew
    }
}

struct Credit: Decodable {
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Decodable, Identifiable {
    let id: Int
    let character: String
    let title: String
    let releaseDate: String
    let posterPath: String?
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w185\(posterPath ?? "")")!
    }
    
    var yearText: String {
        let date = Utils.dateFormatter.date(from: releaseDate)
        if date != nil {
            return FilmData.yearFormatter.string(from: date!)
        }
        return "n/a"
    }
}

struct Crew: Decodable, Identifiable {
    let id: Int
    let department: String
    let title: String
    let releaseDate: String
    let posterPath: String?
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w185\(posterPath ?? "")")!
    }
    
    var yearText: String {
        let date = Utils.dateFormatter.date(from: releaseDate)
        if date != nil {
            return FilmData.yearFormatter.string(from: date!)
        }
        return "n/a"
    }
}

struct Social: Decodable {
    let facebookId: String?
    let twitterId: String?
    let instagramId: String?
    
    var facebookURL: URL? {
        if facebookId != nil { return URL(string: "https://facebook.com/\(facebookId!)") }
        else { return nil }
    }
    
    var twitterURL: URL? {
        if twitterId != nil { return URL(string: "https://twitter.com/\(twitterId!)") }
        else { return nil }
    }
    
    var instagramURL: URL? {
        if instagramId != nil { return URL(string: "https://instagram.com/\(instagramId!)") }
        else { return nil }
    }
}
