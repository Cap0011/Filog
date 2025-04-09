//
//  FilmViewModel.swift
//  Filog
//
//  Created by Jiyoung Park on 3/27/25.
//

import Combine
import Foundation

protocol Searchable: Decodable, Identifiable {
    static func search(query: String) -> AnyPublisher<[Self], Never>
}

class SearchViewModel<T: Searchable>: ObservableObject {
    @Published var searchResults: [T] = []
    @Published var searchText: String = ""

    init() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { query -> AnyPublisher<[T], Never> in
                guard !query.isEmpty else {
                    return Just([]).eraseToAnyPublisher()
                }
                return T.search(query: query)
            }
            .assign(to: &$searchResults)
    }
}
