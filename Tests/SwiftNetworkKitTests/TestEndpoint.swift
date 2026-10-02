//
//  TestEndpoint.swift
//  SwiftNetworkKit
//
//  Created by Anurag on 02/10/26.
//

import Foundation
import SwiftNetworkKit

enum TestEndpoint: Endpoint {
    case user
    
    var path: String {
        "/users/1"
    }
    
    var method: HTTPMethod {
        .get
    }
}
