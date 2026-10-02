//
//  MockNetworkSession.swift
//  BankingNetworkKit
//
//  Created by Anurag on 02/10/26.
//

import Foundation
@testable import SwiftNetworkKit

final class MockNetworkSession: NetworkSession {

    var data: Data
    var response: URLResponse

    init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let reqUrl = request.url {
            print("Request received by mock:", reqUrl)
        }
        return (data, response)
    }
}
