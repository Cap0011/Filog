//
//  Recommender.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/28.
//

import CoreML
import SwiftUI

class Recommender: ObservableObject {
    @Published var filmIDs = [String]()

    init() {
        loadLinks()
    }
    
    private func loadLinks() {
        do {
            let filePath = Bundle.main.path(forResource: "links", ofType: "csv")
            let content = try String(contentsOfFile: filePath ?? "")
            let parsedCSV: [String] = content.components(
                separatedBy: "\n"
            )
            
            let MLIDs: [String] = parsedCSV.map{ $0.components(separatedBy: ",").first! }
            let TMDBIDs: [String] = parsedCSV.map{ String($0.components(separatedBy: ",").last!.dropLast(1)) }
            
            for i in 0..<MLIDs.count {
                Constants.shared.MLtoTMDB[String(MLIDs[i])] = TMDBIDs[i]
                Constants.shared.TMDBtoML[String(TMDBIDs[i])] = MLIDs[i]
           }
        }
        catch(let error) {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func userRatings() -> [Int64: Double] {
        var ratings: [Int64: Double] = [:]
        Constants.shared.films.forEach { film in
            if film.id != nil && Constants.shared.TMDBtoML[film.id!] != nil {
                if film.recommend && film.recommendsub {
                    ratings[Int64(Constants.shared.TMDBtoML[film.id!]!)!] = 5.0
                } else if !film.recommend {
                    ratings[Int64(Constants.shared.TMDBtoML[film.id!]!)!] = 0.0
                } else {
                    ratings[Int64(Constants.shared.TMDBtoML[film.id!]!)!] = 3.5
                }
            }
        }
        return ratings
    }
    
    private func ratedFilmIDs() -> Array<Int64> {
        var IDs = Array<Int64>()
        Constants.shared.films.forEach { film in
            if Constants.shared.TMDBtoML[film.id!] != nil {
                IDs.append(Int64(Constants.shared.TMDBtoML[film.id!]!) ?? 0)
            }
        }
        return IDs
    }
    
    func load() {
        do{
            let config = MLModelConfiguration()
            let model = try MyMovieRecommender(configuration: config)
            let ratings = userRatings()
            if ratings.isEmpty { return }
            let input = MyMovieRecommenderInput(items: userRatings(), k: 50, restrict_: [], exclude: ratedFilmIDs())

            let result = try model.prediction(input: input)
            var tempFilms = [String]()
            
            result.recommendations.sort(by: { result.scores[$0] ?? 0 > result.scores[$1] ?? 0 })
            
            for id in result.recommendations {
                if Constants.shared.MLtoTMDB[String(id)] != nil {
                    tempFilms.append(Constants.shared.MLtoTMDB[String(id)]!)
                }
            }
            filmIDs = tempFilms
        } catch(let error) {
            print("Error: \(error.localizedDescription)")
        }
    }
}
