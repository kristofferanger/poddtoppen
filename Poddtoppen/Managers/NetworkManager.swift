//
//  NetworkManager.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-03.
//

import Foundation
import Combine

class NetworkingManager {
    
    private static let apiKey = "4cc5b103e0df438cb3ab6979dccac610" //old: "b834fb29d33d4b0daaf8c18946748de0"
    private static let baseUrl = "https://listen-api.listennotes.com/api/v2"
    private static let testApi = "https://listen-api-test.listennotes.com/api/v2"

    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL, statusCode: Int)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url, let statusCode): return "[🔥] Status code: \(statusCode). Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func url(endpoint: String) -> URL? {
        switch Constants.api {
        case .production:
            return URL(string: baseUrl + endpoint)
        case .test:
            return URL(string: testApi + endpoint)
        case .mock:
            fatalError("[🛑] Mock data service should not be using the network!")
        }
    }

    static func download(url: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-ListenAPI-Key")
        request.httpMethod = "GET"
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { try handleURLResponse(output: $0, url: url) }
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkingError.unknown
        }
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: response.url ?? url, statusCode: response.statusCode)
        }
        return output.data
    }
    
    static func defaultDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
