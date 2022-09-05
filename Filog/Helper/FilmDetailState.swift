//
//  FilmDetailState.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

@MainActor
class FilmDetailState: ObservableObject {
    
    private let filmService: FilmDataService
    
    @Published var film: FilmData?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(filmService: FilmDataService = FilmDataStore.shared) {
        self.filmService = filmService
    }
    
    func loadFilm(id: Int) async {
        self.film = nil
        self.isLoading = true
        
        do {
            let film = try await self.filmService.fetchFilm(id: id)
            self.film = film
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
}
