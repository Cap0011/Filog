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
    
    func fetchFilms(from endpoint: FilmListEndpoint, completion: @escaping (Result<FilmResponse, FilmError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fetchFilm(id: Int, completion: @escaping (Result<FilmData, FilmError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "append_to_response": "videos,credits"
        ], completion: completion)
    }
    
    func fetchPerson(id: Int, completion: @escaping (Result<PersonData, FilmError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/person/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "append_to_response": "movie_credits,external_ids"
        ], completion: completion)
    }

    func fetchSimilarFilms(id: Int, completion: @escaping (Result<FilmResponse, FilmError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)/similar") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fetchRecommendationFilms(id: Int, completion: @escaping (Result<FilmResponse, FilmError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)/recommendations") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func searchFilm(query: String, completion: @escaping (Result<FilmResponse, FilmError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-GB",
            "include_adult": "true",
            "region": "GB",
            "query": query
        ], completion: completion)
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, FilmError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, FilmError>, completion: @escaping (Result<D, FilmError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
