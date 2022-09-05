//
//  FilmListState.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

class FilmListState: ObservableObject {
    
    @Published var films: [FilmData]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private let filmService: FilmDataService
    
    init(filmService: FilmDataService = FilmDataStore.shared) {
        self.filmService = filmService
    }
    
    func loadFilms(with endpoint: FilmListEndpoint) {
        self.films = nil
        self.isLoading = false
        
        self.filmService.fetchFilms(from: endpoint) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let response):
                self.films = response.results
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    func loadFilms(with ids: [String]) {
        self.films = []
        self.isLoading = false
        
        ids.forEach { id in
            self.filmService.fetchFilm(id: Int(id)!) { [weak self] (result) in
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success(let film):
                    self.films!.append(film)
                case .failure(let error):
                    self.error = error as NSError
                }
            }
        }
    }
    
    func loadSimilarFilms(id: Int) {
        self.films = nil
        self.isLoading = false
        
        self.filmService.fetchSimilarFilms(id: id) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let response):
                self.films = response.results
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    func loadRecommendationFilms(id: Int) {
        self.films = nil
        self.isLoading = false
        
        self.filmService.fetchRecommendationFilms(id: id) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let response):
                self.films = response.results
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
