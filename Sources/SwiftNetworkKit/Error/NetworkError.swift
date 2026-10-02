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
            return "\(statusCode) → HTTP request failed, \(httpMessage(for: statusCode))"
        }
    }

    private func httpMessage(for statusCode: Int) -> String {
        switch statusCode {
        case 400:
            return "Bad request"
        case 401:
            return "Unauthorized"
        case 403:
            return "Forbidden"
        case 404:
            return "Not found"
        case 408:
            return "Request timed out"
        case 429:
            return "Too many requests"
        case 500:
            return "Internal server error"
        case 502:
            return "Bad gateway"
        case 503:
            return "Service unavailable"
        default:
            return "Unknown HTTP error"
        }
    }
}
