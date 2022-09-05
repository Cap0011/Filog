//
//  FilmDataStore.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import Foundation

class FilmDataStore: FilmDataService {
    static let shared = FilmDataStore()
    private init() {}
    
    private let apiKey = Secret.apiKey
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    func fetchFilms(from endpoint: FilmListEndpoint) async throws -> [FilmData] {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            throw FilmError.invalidEndpoint
        }
        let filmResponse: FilmResponse = try await self.loadURLAndDecode(url: url)
        return filmResponse.results
    }
    
    func fetchFilm(id: Int) async throws -> FilmData {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            throw FilmError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url, params: [
            "append_to_response": "videos,credits"
        ])
    }
    
    func fetchPerson(id: Int) async throws -> PersonData {
        guard let url = URL(string: "\(baseAPIURL)/person/\(id)") else {
            throw FilmError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url, params: [
            "append_to_response": "movie_credits,external_ids"
        ])
    }

    func fetchSimilarFilms(id: Int) async throws -> [FilmData] {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)/similar") else {
            throw FilmError.invalidEndpoint
        }
        let filmResponse: FilmResponse = try await self.loadURLAndDecode(url: url)
        return filmResponse.results
    }
    
    func fetchRecommendationFilms(id: Int) async throws -> [FilmData] {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)/recommendations") else {
            throw FilmError.invalidEndpoint
        }
        let filmResponse: FilmResponse = try await self.loadURLAndDecode(url: url)
        return filmResponse.results
    }
    
    func searchFilm(query: String) async throws -> [FilmData] {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            throw FilmError.invalidEndpoint
        }
        let filmResponse: FilmResponse = try await self.loadURLAndDecode(url: url, params: [
            "language": "en-GB",
            "include_adult": "true",
            "region": "GB",
            "query": query
        ])
        return filmResponse.results
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil) async throws -> D {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw FilmError.invalidEndpoint
        }
                
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            throw FilmError.invalidEndpoint
        }
        
        let (data, response) = try await urlSession.data(from: finalURL)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw FilmError.invalidEndpoint
        }
        
        return try self.jsonDecoder.decode(D.self, from: data)
    }
}
