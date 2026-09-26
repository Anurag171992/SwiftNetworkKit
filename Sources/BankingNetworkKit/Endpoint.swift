//
//  File.swift
//  BankingNetworkKit
//
//  Created by Anurag on 26/09/26.
//

import Foundation

//Any type conforming to this Endpoint must provide implemention to these.
public protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    
    //Example: accountID: Value, limit: Value
    //Nil: Parameters are not required for every endpoint.
    //nil clearly represents that this endpoint doesn't have query parameters.
    var queryParameters: [String: String]? { get }
    var headers: [String: String]? { get }
}

/*
 The protocol extension provides a default implementation, so conforming types don't need to implement that requirement unless they need custom behavior.
 */
public extension Endpoint {
    var queryParameters: [String: String]? {
        return nil
    }
    
    var headers: [String: String]? {
        nil
    }
}
