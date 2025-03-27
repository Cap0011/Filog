//
//  FilmViewModel.swift
//  Filog
//
//  Created by Jiyoung Park on 3/27/25.
//

import Combine
import Foundation

class FilmViewModel: ObservableObject {
    @Published var searchResults: [FilmData] = []
    @Published var searchText: String = ""

    init() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { query -> AnyPublisher<[FilmData], Never> in
                guard !query.isEmpty else {
                    return Just([]).eraseToAnyPublisher()
                }
                return FilmService.shared.searchFilms(query: query)
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
            .assign(to: &$searchResults)
    }
}
