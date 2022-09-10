//
//  FilmData.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import Foundation

struct FilmResponse: Decodable {
    let results: [FilmData]
}

struct FilmData: Decodable, Identifiable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let adult: Bool
    let genreIds: [Int]?
    
    let genres: [FilmGenre]?
    let credits: FilmCredit?
    let videos: FilmVideoResponse?
    
    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath ?? "")")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w342\(posterPath ?? "")")!
    }
    
    var netflixSearchURL: URL? {
        var query = ""
        title.forEach { character in
            if character == " " { query.append("%20") }
            else if character == ":" { query.append("%3A") }
            else if character == "'" {query.append("%27")}
            else if character == "," {query.append("%2C")}
            else if character.isLetter { query.append(character) }
        }
        
        return URL(string: "nflx://www.netflix.com/search?q=\(query)")
    }
    
    var genreText: String {
        if self.genres != nil && self.genres!.count > 0 {
            var text = ""
            self.genres!.prefix(3).forEach { genre in
                text = "\(text)\(genre.name), "
            }
            return String(text.dropLast(2))
        } else {
            return "n/a"
        }
    }
    
    var genresToNumber: Int {
        var result = 1
        if self.genres != nil && self.genres!.count > 0 {
            self.genres!.prefix(3).forEach { genre in
                result += Int(pow(2.0, Double(Constants.shared.genreDictionary[genre.id]!)))
            }
        }
        return result
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return FilmData.yearFormatter.string(from: date)
    }
    
    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "n/a"
        }
        
        return "\(runtime / 60)h \(runtime % 60)m"
    }
    
    var adultText: String {
        if adult { return " · R" }
        else { return "" }
    }
    
    var cast: [FilmCast]? {
        credits?.cast
    }
    
    var crew: [FilmCrew]? {
        credits?.crew
    }
    
    var directors: [FilmCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    
    var producers: [FilmCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    
    var screenWriters: [FilmCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }
    
    var youtubeTrailers: [FilmVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }
}

struct FilmGenre: Decodable {
    let name: String
    let id: Int
}

struct FilmCredit: Decodable {
    let cast: [FilmCast]
    let crew: [FilmCrew]
}

struct FilmCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
    let profilePath: String?
    
    var profileURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w185\(profilePath ?? "")")!
    }
}

struct FilmCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
    let profilePath: String?
    
    var profileURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w185\(profilePath ?? "")")!
    }
}

struct FilmVideoResponse: Decodable {
    let results: [FilmVideo]
}

struct FilmVideo: Decodable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
    
    var youtubeThumbnailURL: URL? {
        return URL(string: "https://img.youtube.com/vi/\(key)/0.jpg")
    }
}
