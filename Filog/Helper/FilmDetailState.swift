//
//  FilmDetailState.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

class FilmDetailState: ObservableObject {
    
    private let filmService: FilmDataService
    
    @Published var film: FilmData?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(filmService: FilmDataService = FilmDataStore.shared) {
        self.filmService = filmService
    }
    
    func loadFilm(id: Int) {
        self.film = nil
        self.isLoading = false
        self.filmService.fetchFilm(id: id) { [weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let film):
                self.film = film
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
