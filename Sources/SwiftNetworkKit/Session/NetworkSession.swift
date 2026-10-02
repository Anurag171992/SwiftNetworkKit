//
//  File.swift
//  BankingNetworkKit
//
//  Created by Anurag on 02/10/26.
//

import Foundation

public protocol NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {
    
}
