//
//  DetailViewModel.swift
//  Filog
//
//  Created by Jiyoung Park on 4/16/25.
//

import Combine

protocol DetailFetchable: Decodable {
    static var detailPathComponent: String { get }
    static var queryItems: [String : String]? { get }
}

class DetailViewModel<T: DetailFetchable>: ObservableObject {
    @Published var detail: T?
    @Published var id: Int? {
        didSet {
            if id != nil {
                fetchDetail()
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchDetail() {
        FilmService.shared.fetchDetail(id: id!)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching detail: \(error)")
                    }
                },
                receiveValue: { [weak self] detail in
                    self?.detail = detail
                }
            )
            .store(in: &cancellables)
    }
}
