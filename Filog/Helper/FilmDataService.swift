//
//  FilmDataService.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import Foundation

protocol FilmDataService {
    func fetchFilms(from endpoint: FilmListEndpoint, completion: @escaping (Result<FilmResponse, FilmError>) -> ())
    func fetchFilm(id: Int, completion: @escaping (Result<FilmData, FilmError>) -> ())
    func fetchPerson(id: Int, completion: @escaping (Result<PersonData, FilmError>) -> ())
    func fetchSimilarFilms(id: Int, completion: @escaping (Result<FilmResponse, FilmError>) -> ())
    func fetchRecommendationFilms(id: Int, completion: @escaping (Result<FilmResponse, FilmError>) -> ())
    func searchFilm(query: String, completion: @escaping (Result<FilmResponse, FilmError>) -> ())
}

enum FilmListEndpoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    
    var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        }
    }
}

enum FilmError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}
