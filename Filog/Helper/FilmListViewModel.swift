//
//  FilmListViewModel.swift
//  Filog
//
//  Created by Jiyoung Park on 3/28/25.
//

import Combine
import Foundation

class FilmListViewModel: ObservableObject {
    @Published var films: [FilmData]?
    @Published var isLoading = false
    
    let endpoint: FilmListEndpoint
    private var cancellables = Set<AnyCancellable>()

    init(endpoint: FilmListEndpoint) {
        self.endpoint = endpoint
        isLoading = true
        fetchFilms()
    }
    
    func fetchFilms() {
        FilmService.shared.fetchFilms(from: endpoint)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching films: \(error)")
                    }
                },
                receiveValue: { [weak self] films in
                    self?.films = films
                    self?.isLoading = false
                }
            )
            .store(in: &cancellables)
    }
}
