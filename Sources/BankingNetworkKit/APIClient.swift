//
//  File.swift
//  BankingNetworkKit
//
//  Created by Anurag on 02/10/26.
//

import Foundation

public struct APIClient {
    
    private let requestBuilder: RequestBuilder
    private let session: any NetworkSession

    public init(requestBuilder: RequestBuilder, session: any NetworkSession) {
        self.requestBuilder = requestBuilder
        self.session = session
    }
    
    public func request<T: Decodable>(endpoint: any Endpoint, responseType: T.Type) async throws -> T {
        
        let request = try requestBuilder.buildRequest(from: endpoint)
        let (data, response) = try await session.data(for: request)
        
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
