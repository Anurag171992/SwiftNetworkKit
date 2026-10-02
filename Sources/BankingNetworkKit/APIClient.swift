//
//  File.swift
//  BankingNetworkKit
//
//  Created by Anurag on 02/10/26.
//

import Foundation

public struct APIClient {
    
    private let requestBuilder: RequestBuilder
    
    public init(requestBuilder: RequestBuilder) {
        self.requestBuilder = requestBuilder
    }
    
    public func request<T: Decodable>(endpoint: any Endpoint, responseType: T.Type) async throws -> T {
        
        let request = try requestBuilder.buildRequest(from: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        
        return decodedResponse
    }
}
