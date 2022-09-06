//
//  FilmListState.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

@MainActor
class FilmListState: ObservableObject {
    
    @Published var films: [FilmData]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private let filmService: FilmDataService
    
    init(filmService: FilmDataService = FilmDataStore.shared) {
        self.filmService = filmService
    }
    
    func loadFilms(with endpoint: FilmListEndpoint) async {
        self.films = nil
        self.isLoading = false
        
        do {
            let films = try await filmService.fetchFilms(from: endpoint)
            self.films = films
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
    
    func loadFilms(with ids: [String]) async {
        self.films = []
        self.isLoading = false
        
        let convertedIDs = ids.map { Int($0) }
        
        do {
            let films = try await withThrowingTaskGroup(of: FilmData?.self) { group -> [FilmData] in
                for id in convertedIDs {
                    group.addTask {
                        return try? await self.filmService.fetchFilm(id: id!)
                    }
                }
                
                var collected = [FilmData]()
                
                for try await value in group {
                    if value != nil {
                        collected.append(value!)
                    }
                }
                return collected
            }
            
            self.films = films
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
    
    func loadSimilarFilms(id: Int) async {
        self.films = nil
        self.isLoading = false
        
        do {
            let films = try await filmService.fetchSimilarFilms(id: id)
            self.films = films
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
    
    func loadRecommendationFilms(id: Int) async {
        self.films = nil
        self.isLoading = false
        
        do {
            let films = try await filmService.fetchRecommendationFilms(id: id)
            self.films = films
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
}
