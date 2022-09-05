//
//  FilmDataService.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import Foundation

protocol FilmDataService {
    func fetchFilms(from endpoint: FilmListEndpoint) async throws -> [FilmData]
    func fetchFilm(id: Int) async throws -> FilmData
    func fetchPerson(id: Int) async throws -> PersonData
    func fetchSimilarFilms(id: Int) async throws -> [FilmData]
    func fetchRecommendationFilms(id: Int) async throws -> [FilmData]
    func searchFilm(query: String) async throws -> [FilmData]
}

enum FilmListEndpoint: String, CaseIterable, Identifiable {
    
    var id: String { rawValue}
    
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
