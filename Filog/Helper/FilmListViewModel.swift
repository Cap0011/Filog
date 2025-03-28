//
//  FilmListViewModel.swift
//  Filog
//
//  Created by Jiyoung Park on 3/28/25.
//

import Combine
import Foundation

class FilmListViewModel: ObservableObject {
    @Published var films: [FilmData] = []
    
    private let endpoint: FilmListEndpoint
    
    var imageType: FilmCarouselView.ImageType {
        return endpoint.imageType
    }
    
    init(endpoint: FilmListEndpoint) {
        self.endpoint = endpoint
    }
    
}
