//
//  Constants.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/28.
//

import SwiftUI

class Constants {
    static let shared = Constants()

    var films = [FetchedResults<Film>.Element]()
    
    var MLtoTMDB: [String: String] = [:]
    
    var TMDBtoML: [String: String] = [:]
    
    let genreDictionary: [Int: Int] = [28: 1, 12: 2, 16: 3, 35: 4, 80: 5, 99: 6, 18: 7, 10751: 8, 14: 9, 36: 10, 27: 11, 10402: 12, 9648: 13, 10749: 14, 878: 15, 10770: 16, 53: 17, 10752: 18, 37: 19]
}
