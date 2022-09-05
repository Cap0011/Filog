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
}
