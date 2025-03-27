//
//  FilmService.swift
//  Filog
//
//  Created by Jiyoung Park on 3/26/25.
//

import Combine
import Foundation

enum APIError: Error {
    case invalidResponse
    case serverError(statusCode: Int)
}

class FilmService {
    static let shared = FilmService()
    private let baseURL = "https://api.themoviedb.org/3"
    
    func searchFilms(query: String) -> AnyPublisher<[FilmData], Error> {
        guard let url = URL(string: "\(baseURL)/search/movie") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: Secret.apiKey),
            URLQueryItem(name: "include_adult", value: "true"),
            URLQueryItem(name: "language", value: "en-GB"),
            URLQueryItem(name: "region", value: "GB"),
            URLQueryItem(name: "query", value: query)
        ]
        
        components.queryItems = queryItems
        
        guard let finalURL = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: finalURL)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.serverError(statusCode: httpResponse.statusCode)
                }
                return data
            }
            .decode(type: FilmResponse.self, decoder: Utils.jsonDecoder)
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
