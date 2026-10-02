//
//  File.swift
//  BankingNetworkKit
//
//  Created by Anurag on 02/10/26.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)

    public var errorDescription: String? {
        
        switch self {
        case .invalidURL:
            return "Invalid URL"

        case .invalidResponse:
            return "Invalid response"

        case .httpError(let statusCode):
            return "HTTP request failed with status code: \(statusCode)"
        }
    }
}
