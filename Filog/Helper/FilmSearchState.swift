//
//  FilmSearchState.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI
import Combine
import Foundation

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
                
        }.throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] in self?.search(query: $0) }
    }
    
    func search(query: String) {
        self.films = nil
        self.isLoading = false
        self.error = nil
        
        guard !query.isEmpty else {
            return
        }
        
        self.isLoading = true
        self.filmService.searchFilm(query: query) {[weak self] (result) in
            guard let self = self, self.query == query else { return }
            
            self.isLoading = false
            switch result {
            case .success(let response):
                self.films = response.results
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    deinit {
        self.subscriptionToken?.cancel()
        self.subscriptionToken = nil
    }
}
