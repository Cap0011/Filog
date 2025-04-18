//
//  FilmService.swift
//  Filog
//
//  Created by Jiyoung Park on 3/26/25.
//

import Combine
import Foundation

class FilmService {
    enum APIError: Error {
        case invalidResponse
        case serverError(statusCode: Int)
    }
    
    static let shared = FilmService()
    private let baseURL = "https://api.themoviedb.org/3"
    
    func searchFilms(query: String) -> AnyPublisher<[FilmData], Error> {
        guard let url = makeURL(for: "search/movie", queryItemValues: ["include_adult": "true", "language": "en-GB", "region": "GB", "query": query ]) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return fetchData(from: url)
            .decode(type: FilmResponse.self, decoder: Utils.jsonDecoder)
            .map(\.results)
            .eraseToAnyPublisher()
    }
    
    func searchShows(query: String) -> AnyPublisher<[Show], Error> {
        guard let url = makeURL(for: "search/tv", queryItemValues: ["include_adult": "true", "language": "en-GB", "query": query ]) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        print(url)
        return fetchData(from: url)
//            .decode(type: ShowResponse.self, decoder: Utils.jsonDecoder)
            .tryMap { data -> ShowResponse in
                do {
                    return try Utils.jsonDecoder.decode(ShowResponse.self, from: data)
                } catch {
                    print("Decoding error:", error)
                    throw error
                }
            }
            .map(\.results)
            .eraseToAnyPublisher()
    }
    
    func searchPeople(query: String) -> AnyPublisher<[Person], Error> {
        guard let url = makeURL(for: "search/person", queryItemValues: ["include_adult": "true", "language": "en-GB", "query": query ]) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return fetchData(from: url)
            .decode(type: PersonSearchResponse.self, decoder: Utils.jsonDecoder)
            .map(\.results)
            .eraseToAnyPublisher()
    }

    func fetchFilms(from endpoint: FilmListEndpoint) -> AnyPublisher<[FilmData], Error> {
        guard let url = makeURL(for: "movie/\(endpoint.rawValue)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return fetchData(from: url)
            .decode(type: FilmResponse.self, decoder: Utils.jsonDecoder)
            .map(\.results)
            .eraseToAnyPublisher()
    }
    
    func fetchDetail<T: DetailFetchable>(id: Int) -> AnyPublisher<T, Error> {
        guard let url = makeURL(for: "\(T.detailPathComponent)/\(id)", queryItemValues: T.queryItems) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return fetchData(from: url)
            .decode(type: T.self, decoder: Utils.jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    private func makeURL(for endpoint: String, queryItemValues: [String: String]? = nil) -> URL? {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else { return nil }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        
        var queryItems = [URLQueryItem(name: "api_key", value: Secret.apiKey)]
        if let values = queryItemValues {
            queryItems.append(contentsOf: values.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        components.queryItems = queryItems
        
        return components.url
    }
    
    private func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.serverError(statusCode: httpResponse.statusCode)
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
