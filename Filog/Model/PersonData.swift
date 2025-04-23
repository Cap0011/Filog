//
//  PersonData.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/31.
//

//import Foundation
//
//struct PersonData: Decodable, Identifiable {
//    let id: Int
//    let birthday: String?
//    let deathday: String?
//    let name: String
//    let biography: String
//    let placeOfBirth: String?
//    let profilePath: String?
//    
//    let movieCredits: Credit?
//    
//    let externalIds: Social?
//    
//    var profileURL: URL {
//        return URL(string: "https://image.tmdb.org/t/p/w185\(profilePath ?? "")")!
//    }
//    
//    var cast: [Cast]? {
//        movieCredits?.cast
//    }
//    
//    var crew: [Crew]? {
//        movieCredits?.crew
//    }
//}
//
//struct Credit: Decodable {
//    let cast: [Cast]
//    let crew: [Crew]
//}
