//
//  ComicAPIService.swift
//  Comic Collection
//
//  Created by Sourav on 21/10/25.
//

import Foundation
import Combine

// MARK: - Service Layer (Network & Persistence)

protocol ComicAPIServiceProtocol {
    func fetchComic(number: Int?) -> AnyPublisher<Comic, Error>
}

// This is the API service, responsible ONLY for fetching data (Used Single Responsibility).
final class ComicAPIService: ComicAPIServiceProtocol {
    private let baseURL = "https://xkcd.com"
    private let urlExtension = "/info.0.json"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchComic(number: Int?) -> AnyPublisher<Comic, Error> {
        let urlString = number.map { "\(baseURL)/\($0)\(urlExtension)" } ?? "\(baseURL)\(urlExtension)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Comic.self, decoder: JSONDecoder())
            .mapError { error in
                // Map Error (TODO)
                return error as Error
            }
            .eraseToAnyPublisher()
    }
}

//Some generic error
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}
