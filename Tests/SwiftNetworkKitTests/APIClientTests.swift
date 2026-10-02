//
//  APIClientTests.swift
//  BankingNetworkKit
//
//  Created by Anurag on 02/10/26.
//

import XCTest
@testable import SwiftNetworkKit

final class APIClientTests: XCTestCase {
    
    private let baseURL = URL(string: "https://example.com")!
    private let userURL = URL(string: "https://example.com/users/1")!
    
    //MARK: - Success
    func testResponseSuccessful() async throws {
        //ARRANGE
        let apiClient = makeAPIClient(statusCode: 200,
        json: """
            {
                "id": 1,
                "name": "John"
            }
            """
        )
        
        //ACT
        let user: TestUser = try await apiClient.request(endpoint: TestEndpoint.user,responseType: TestUser.self)
        
        //ASSERT
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "John")
    }
    
    //MARK: - HTTP Errors
    func testResponseWithError400() async {
        await assertHTTPError(statusCode: 400)
    }
    
    func testResponseWithError401() async {
        await assertHTTPError(statusCode: 401)
    }
    
    func testResponseWithError403() async {
        await assertHTTPError(statusCode: 403)
    }
    
    func testResponseWithError404() async {
        await assertHTTPError(statusCode: 404)
    }
    
    func testResponseWithError408() async {
        await assertHTTPError(statusCode: 408)
    }
    
    func testResponseWithError429() async {
        await assertHTTPError(statusCode: 429)
    }
    
    func testResponseWithError500() async {
        await assertHTTPError(statusCode: 500)
    }
    
    func testResponseWithError502() async {
        await assertHTTPError(statusCode: 502)
    }
    
    func testResponseWithError503() async {
        await assertHTTPError(statusCode: 503)
    }
    
    private func assertHTTPError(statusCode expectedStatusCode: Int) async {
        //ARRANGE
        let apiClient = makeAPIClient(statusCode: expectedStatusCode)
        //ACT
        do {
            let _: TestUser = try await apiClient.request(endpoint: TestEndpoint.user, responseType: TestUser.self)
            //ASSERT
            XCTFail("Expected request to throw an error")
        } catch let error as NetworkError {
            print("Error:", error.localizedDescription)
            //ASSERT
            switch error {
            case .httpError(let actualStatusCode):
                XCTAssertEqual(actualStatusCode, expectedStatusCode)
            default:
                XCTFail("Expected httpError but received \(error)")
            }
            
        } catch {
            XCTFail("Expected NetworkError but received \(error)")
        }
    }
    
    //MARK: - Helpers
    private func makeAPIClient(statusCode: Int, json: String = "{}") -> APIClient {
        let data = Data(json.utf8)
        let response = HTTPURLResponse(
            url: userURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        let mockSession = MockNetworkSession(data: data, response: response)
        let requestBuilder = RequestBuilder(baseURL: baseURL)
        return APIClient(requestBuilder: requestBuilder, session: mockSession)
    }
    
}
