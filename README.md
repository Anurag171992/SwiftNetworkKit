# SwiftNetworkKit

A lightweight, reusable, and testable networking layer for iOS applications built with **Swift**, **Swift Package Manager (SPM)**, and **Swift Concurrency**.

SwiftNetworkKit separates common networking infrastructure from application-specific feature code. It provides endpoint-based request configuration, request building, generic response decoding, dependency injection, HTTP response validation, structured error handling, and testable network execution.

---

## 🚀 Features

- Swift Package Manager based reusable networking library
- Type-safe HTTP methods
- Endpoint-based API design
- URLRequest construction
- Query parameter support
- Custom request headers
- Encodable request body support
- Generic `Decodable` response handling
- Swift Concurrency with `async/await`
- HTTP status-code validation
- Structured network errors using `LocalizedError`
- Dependency injection
- Protocol-based network session abstraction
- Mock networking support
- Unit testing with XCTest
- Separation of networking infrastructure from application-specific code

---

## 🏗 Architecture

```text
Consumer Application
        │
        ▼
     Endpoint
        │
        ▼
  RequestBuilder
        │
        ▼
    APIClient
        │
        ▼
 NetworkSession
        │
        ▼
   URLSession
        │
        ▼
 Data + URLResponse
        │
        ▼
HTTPURLResponse
        │
        ▼
Status Validation
        │
        ▼
   JSONDecoder
        │
        ▼
 Decodable Model
```

Each component has a focused responsibility.

The consuming application defines its own endpoints and response models, while SwiftNetworkKit handles the reusable networking infrastructure.

---

## 📦 Package Structure

```text
SwiftNetworkKit
│
├── Package.swift
│
├── Sources
│   └── SwiftNetworkKit
│       ├── APIClient
│       │   └── APIClient.swift
│       ├── Endpoint
│       │   ├── Endpoint.swift
│       │   └── HTTPMethod.swift
│       ├── Error
│       │   └── NetworkError.swift
│       ├── Request
│       │   └── RequestBuilder.swift
│       └── Session
│           └── NetworkSession.swift
│
└── Tests
    └── SwiftNetworkKitTests
        ├── APIClientTests.swift
        ├── MockNetworkSession.swift
        ├── TestEndpoint.swift
        └── TestUser.swift
```

---

## 🌐 Type-Safe HTTP Methods

Instead of using raw HTTP method strings throughout an application:

```swift
request.httpMethod = "GET"
```

SwiftNetworkKit provides a type-safe `HTTPMethod`:

```swift
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
```

Example:

```swift
let method: HTTPMethod = .get
```

---

## 🎯 Endpoint-Based API Design

An `Endpoint` describes what is required to make a request.

```swift
public protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: (any Encodable)? { get }
}
```

Optional values have default implementations, allowing simple endpoints to define only what they require.

Application-specific endpoints remain in the consuming application.

Example:

```swift
enum UserEndpoint {
    case user(id: Int)
}

extension UserEndpoint: Endpoint {

    var path: String {
        switch self {
        case .user(let id):
            return "/users/\(id)"
        }
    }

    var method: HTTPMethod {
        .get
    }
}
```

SwiftNetworkKit does not need to understand what a user, account, payment, or transaction represents.

---

## 🔨 Request Building

`RequestBuilder` converts an `Endpoint` into a `URLRequest`.

It is responsible for:

```text
Base URL + Path
        ↓
Query Parameters
        ↓
HTTP Method
        ↓
Headers
        ↓
Request Body
        ↓
URLRequest
```

Example:

```swift
let requestBuilder = RequestBuilder(
    baseURL: URL(string: "https://api.example.com")!
)
```

The base URL is injected rather than being hardcoded inside individual endpoints.

This allows the consuming application to control the server/environment configuration.

---

## ⚡ APIClient

`APIClient` coordinates request execution, response validation, and decoding.

```swift
let apiClient = APIClient(
    requestBuilder: requestBuilder,
    session: URLSession.shared
)
```

A request can then be performed using any `Endpoint`:

```swift
let user: UserResponse = try await apiClient.request(
    endpoint: UserEndpoint.user(id: 1),
    responseType: UserResponse.self
)
```

Internally:

```text
Endpoint
   ↓
RequestBuilder
   ↓
URLRequest
   ↓
NetworkSession
   ↓
Data + URLResponse
   ↓
HTTP Validation
   ↓
JSONDecoder
   ↓
T
```

---

## 🧩 Generic Response Decoding

`APIClient` supports any response type conforming to `Decodable`.

```swift
public func request<T: Decodable>(
    endpoint: any Endpoint,
    responseType: T.Type
) async throws -> T
```

For example:

```swift
let user: UserResponse = try await apiClient.request(
    endpoint: UserEndpoint.user(id: 1),
    responseType: UserResponse.self
)
```

The networking package does not need to know about `UserResponse`.

It only knows that `T` conforms to `Decodable`.

---

## ⚠️ Error Handling

SwiftNetworkKit provides structured networking errors using `LocalizedError`.

```swift
public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
}
```

The current error handling covers:

```text
Invalid URL
Invalid HTTP response
Non-success HTTP status codes
```

HTTP status codes can also provide readable descriptions.

Examples:

```text
400 → HTTP request failed, Bad request
401 → HTTP request failed, Unauthorized
403 → HTTP request failed, Forbidden
404 → HTTP request failed, Not found
408 → HTTP request failed, Request timed out
429 → HTTP request failed, Too many requests
500 → HTTP request failed, Internal server error
502 → HTTP request failed, Bad gateway
503 → HTTP request failed, Service unavailable
```

Unmapped HTTP status codes fall back to:

```text
Unknown HTTP error
```

---

## ✅ HTTP Response Validation

Completing a network request does not necessarily mean the HTTP request was successful.

For example, a server can successfully return:

```text
404 Not Found
500 Internal Server Error
```

SwiftNetworkKit first verifies that the returned `URLResponse` is an `HTTPURLResponse`.

It then validates the HTTP status code:

```text
200...299
    ↓
Successful HTTP response
    ↓
Decode Data

Other status code
    ↓
NetworkError.httpError(statusCode:)
```

This keeps HTTP validation inside the networking layer rather than duplicating it across application features.

---

## 💉 Dependency Injection

`APIClient` does not hardcode `URLSession.shared`.

Instead, it depends on the `NetworkSession` abstraction:

```swift
public protocol NetworkSession {
    func data(
        for request: URLRequest
    ) async throws -> (Data, URLResponse)
}
```

`URLSession` conforms to this protocol:

```swift
extension URLSession: NetworkSession {}
```

Production usage:

```text
APIClient
    ↓
NetworkSession
    ↓
URLSession.shared
    ↓
Real Network
```

Testing:

```text
APIClient
    ↓
NetworkSession
    ↓
MockNetworkSession
    ↓
Fake Data + Response
```

This allows the network execution dependency to be replaced without changing `APIClient`.

---

## 🧪 Unit Testing & Mocking

SwiftNetworkKit uses XCTest and a mock implementation of `NetworkSession`.

Instead of making real network requests during unit tests, the mock can return predefined `Data` and `URLResponse` values.

```text
Fake Data + HTTP Response
            ↓
    MockNetworkSession
            ↓
        APIClient
            ↓
 Validation + Decoding
            ↓
         Assert
```

This makes networking tests deterministic and independent of a real server.

The current tests cover successful response decoding and HTTP error handling scenarios such as:

```text
200 → Successful decoding
400 → Bad Request
404 → Not Found
500 → Internal Server Error
```

---

## 🔐 Module Boundaries

SwiftNetworkKit owns generic networking infrastructure:

```text
SwiftNetworkKit
│
├── Endpoint
├── HTTPMethod
├── RequestBuilder
├── APIClient
├── NetworkSession
└── NetworkError
```

The consuming application owns application-specific code:

```text
Consumer Application
│
├── UserEndpoint
├── AccountEndpoint
├── PaymentEndpoint
├── UserResponse
├── AccountResponse
└── Feature / Business Logic
```

Dependency direction:

```text
Consumer Application
        │
        │ import SwiftNetworkKit
        ▼
   SwiftNetworkKit
```

SwiftNetworkKit does not depend on the consuming application.

---

## 📱 Example Usage

Import the package:

```swift
import SwiftNetworkKit
```

Create the request builder:

```swift
let requestBuilder = RequestBuilder(
    baseURL: URL(string: "https://api.example.com")!
)
```

Create the API client:

```swift
let apiClient = APIClient(
    requestBuilder: requestBuilder,
    session: URLSession.shared
)
```

Define an application-specific endpoint:

```swift
enum UserEndpoint {
    case user(id: Int)
}

extension UserEndpoint: Endpoint {

    var path: String {
        switch self {
        case .user(let id):
            return "/users/\(id)"
        }
    }

    var method: HTTPMethod {
        .get
    }
}
```

Define the application's response model:

```swift
struct UserResponse: Decodable {
    let id: Int
    let name: String
}
```

Perform the request:

```swift
let user: UserResponse = try await apiClient.request(
    endpoint: UserEndpoint.user(id: 1),
    responseType: UserResponse.self
)
```

---

## 🎓 Concepts Demonstrated

SwiftNetworkKit demonstrates practical usage of:

- Swift Package Manager
- iOS modularization
- Swift module boundaries
- Access control
- Protocol-oriented programming
- Dependency injection
- Generics
- `Encodable`
- `Decodable`
- `URL`
- `URLComponents`
- `URLQueryItem`
- `URLRequest`
- `URLSession`
- `URLResponse`
- `HTTPURLResponse`
- HTTP status codes
- Swift Concurrency
- `async/await`
- Error propagation
- `LocalizedError`
- Mocking
- XCTest

---

## 🎯 Project Goal

SwiftNetworkKit is designed as a reusable networking foundation rather than a domain-specific networking implementation.

The package handles generic networking concerns while allowing the consuming application to own its business-specific endpoints, models, and feature logic.

```text
Application-specific code
          │
          ▼
     SwiftNetworkKit
          │
          ▼
       Network
```

The goal is not simply to wrap `URLSession`, but to demonstrate how networking infrastructure can be designed with clear responsibilities, module boundaries, dependency injection, generic decoding, Swift Concurrency, and testability.
