//
//  PersonDetailState.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/31.
//

import SwiftUI

@MainActor
class PersonDetailState: ObservableObject {
    
    private let filmService: FilmDataService
    
    @Published var person: PersonData?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(filmService: FilmDataService = FilmDataStore.shared) {
        self.filmService = filmService
    }
    
    func loadPerson(id: Int) async {
        self.person = nil
        self.isLoading = false
        
        do {
            let person = try await self.filmService.fetchPerson(id: id)
            self.person = person
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
}
