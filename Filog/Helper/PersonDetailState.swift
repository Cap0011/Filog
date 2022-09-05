//
//  PersonDetailState.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/31.
//

import SwiftUI

class PersonDetailState: ObservableObject {
    
    private let filmService: FilmDataService
    
    @Published var person: PersonData?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(filmService: FilmDataService = FilmDataStore.shared) {
        self.filmService = filmService
    }
    
    func loadPerson(id: Int) {
        self.person = nil
        self.isLoading = false
        self.filmService.fetchPerson(id: id) { [weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let person):
                self.person = person
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
