//
//  File.swift
//  BankingNetworkKit
//
//  Created by Anurag on 02/10/26.
//

/*
 The responsibility is to get the description and make a request and provide it to the URLRequest.
 */
import Foundation

public struct RequestBuilder {
    
    private let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func buildRequest(from endpoint: any Endpoint) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let queryParameters = endpoint.queryParameters {
            components?.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        guard let finalURL = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        
        //HTTP Method
        request.httpMethod = endpoint.method.rawValue
        
        //Common header
        request.setValue("application/json",forHTTPHeaderField: "Accept")
        
        //Endpoint-specific headers
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        //Request Body
        if let body = endpoint.body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}
