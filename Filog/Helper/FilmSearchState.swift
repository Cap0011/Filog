//
//  FilmSearchState.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI
import Combine
import Foundation

@MainActor
class FilmSearchState: ObservableObject {
    
    @Published var query = ""
    @Published var films: [FilmData]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private var subscriptionToken: AnyCancellable?
    
    let filmService: FilmDataService
    
    var isEmptyResults: Bool {
        !self.query.isEmpty && self.films != nil && self.films!.isEmpty
    }
    
    init(filmService: FilmDataService = FilmDataStore.shared) {
        self.filmService = filmService
    }
    
    func startObserve() {
        guard subscriptionToken == nil else { return }
        
        self.subscriptionToken = self.$query
            .map { [weak self] text in
                self?.films = nil
                self?.error = nil
                return text
                
            }.debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] (query: String) in
                guard let self = self else { return }
                Task { await self.search(query: query) }
            }
        
    }
    
    func search(query: String) async {
        self.films = nil
        self.isLoading = false
        self.error = nil
        
        guard !query.isEmpty else {
            return
        }
        
        self.isLoading = true
        
        do {
            let films = try await filmService.searchFilm(query: query)
            guard query == self.query else { return }
            self.isLoading = false
            self.films = films
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
    
    deinit {
        self.subscriptionToken?.cancel()
        self.subscriptionToken = nil
    }
}
