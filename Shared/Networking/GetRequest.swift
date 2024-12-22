//
//  GetRequest.swift
//  jingweili.me-mobile
//
//  Created by Jing Wei Li on 11/22/20.
//

import Foundation
import Combine

public class GetRequest {
    private let endpoint: String
    private var queryParameters: [URLQueryItem] = []
    
    private var decoder = JSONDecoder()
    
    
    public init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    // MARK: - Configuration
    
    
    public func addParameter(_ parameter: URLQueryItem) -> GetRequest {
        queryParameters.append(parameter)
        return self
    }
    
    public func setDecoder(_ decoder: JSONDecoder) -> GetRequest {
        self.decoder = decoder
        return self
    }
    
    
    // MARK: - Request Methods
    // MARK: Get
    public func get<Result: Codable>(resultType: Result.Type) -> AnyPublisher<Result, Error> {
        guard var urlComponents = URLComponents(string: endpoint) else {
            return Fail(error: NSError(domain: "Failed to get url", code: 0))
                .eraseToAnyPublisher()
        }
        urlComponents.queryItems = queryParameters
        guard let url = urlComponents.url else {
            return Fail(error: NSError(domain: "Failed to get url", code: 0))
                .eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Result.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    public func get<Result: Codable>(resultType: Result.Type) async throws -> Result {
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw NSError(domain: "Failed to get url", code: 0)
        }
        urlComponents.queryItems = queryParameters
        guard let url = urlComponents.url else {
            throw NSError(domain: "Failed to get url", code: 0)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(Result.self, from: data)
    }
}
