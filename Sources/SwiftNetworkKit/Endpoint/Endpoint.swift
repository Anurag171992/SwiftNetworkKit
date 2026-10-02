//
//  Endpoint.swift
//  SwiftNetworkKit
//
//  Created by Anurag on 26/09/26.
//

import Foundation

//Any type conforming to this Endpoint must provide implemention to these.
public protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: (any Encodable)? { get }
}

/*
 The protocol extension provides a default implementation, so conforming types don't need to implement that requirement unless they need custom behavior.
 */
public extension Endpoint {
    var queryParameters: [String: String]? {
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var body: (any Encodable)? {
        return nil
    }
}
