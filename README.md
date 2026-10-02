
# SwiftNetworkKit - Work In Progress

A modular, reusable, and testable networking layer for iOS applications built with **Swift**, **Swift Package Manager (SPM)**, and **Swift Concurrency**.

BankingNetworkKit demonstrates how a production-style networking layer can be separated from an iOS application into an independent Swift Package with clear module boundaries, type-safe APIs, dependency injection, structured error handling, and unit testing.

The project uses a banking application as the practical use case.

---

## 🚀 Features

* Swift Package Manager based modular architecture
* Type-safe HTTP methods
* Endpoint-based API design
* URLRequest construction
* Generic networking layer
* Generic `Decodable` response handling
* Swift Concurrency with `async/await`
* HTTP status-code validation
* Structured network error handling
* Dependency injection
* Protocol-oriented architecture
* Mock networking implementations
* Unit testing with XCTest
* Clear public and internal API boundaries
* Separation of networking infrastructure from feature code

---

## 🏗 Architecture

The networking flow follows a layered approach:

```text
Banking Application
        │
        ▼
     Endpoint
        │
        ▼
   Request Builder
        │
        ▼
     API Client
        │
        ▼
    URLSession
        │
        ▼
   HTTP Response
        │
        ▼
Response Validation
        │
        ▼
 JSON Decoding
        │
        ▼
 Decodable Model
```

The application does not need to know the internal implementation details of the networking layer.

It communicates with BankingNetworkKit through a small, clearly defined public API.

---

## 📦 Swift Package Structure

```text
BankingNetworkKit
│
├── Package.swift
│
├── Sources
│   └── BankingNetworkKit
│       ├── HTTPMethod.swift
│       ├── Endpoint.swift
│       ├── APIClient.swift
│       ├── NetworkError.swift
│       ├── RequestBuilder.swift
│       └── ResponseValidator.swift
│
└── Tests
    └── BankingNetworkKitTests
        ├── APIClientTests.swift
        ├── RequestBuilderTests.swift
        └── MockNetworkClient.swift
```

The exact implementation is organized so that each component has a focused responsibility.

---

## 🌐 Type-Safe HTTP Methods

Instead of spreading raw HTTP strings throughout the application:

```swift
request.httpMethod = "GET"
```

BankingNetworkKit provides type-safe HTTP methods:

```swift
let method: HTTPMethod = .get
```

Supported methods include:

```text
GET
POST
PUT
PATCH
DELETE
```

This reduces string-based mistakes and makes endpoint definitions easier to understand.

---

## 🎯 Endpoint-Based API Design

API configuration is represented using endpoints.

An endpoint describes information required to construct a network request, such as:

* Path
* HTTP method
* Query parameters
* Headers
* Request body

This keeps API definitions separate from the code responsible for executing network requests.

---

## 🔨 Request Building

BankingNetworkKit converts endpoint definitions into `URLRequest` instances.

Request construction is responsible for configuring values such as:

```text
Base URL
Path
HTTP Method
Headers
Query Parameters
HTTP Body
```

Separating request construction from request execution keeps the networking layer easier to maintain and test.

---

## ⚡ Swift Concurrency

Network requests use Swift's modern concurrency model with:

```swift
async/await
```

For example, the networking layer can expose an API conceptually similar to:

```swift
let account: Account = try await apiClient.request(endpoint)
```

This provides readable asynchronous networking code while supporting Swift's structured concurrency model.

---

## 🧩 Generic Response Decoding

BankingNetworkKit supports generic `Decodable` responses.

The networking layer can therefore decode different API responses without creating separate networking implementations for every model.

For example:

```swift
let account: Account = try await client.request(endpoint)
let transactions: [Transaction] = try await client.request(endpoint)
```

The expected response type determines how the returned JSON is decoded.

---

## ⚠️ Error Handling

Networking failures are represented using structured errors rather than exposing arbitrary implementation details throughout the application.

Errors can represent scenarios such as:

```text
Invalid URL
Invalid Request
Transport Failure
Invalid HTTP Response
HTTP Status Code Failure
Decoding Failure
```

This allows feature modules to handle networking failures consistently.

---

## ✅ Response Validation

HTTP responses are validated before response data is decoded.

The networking layer verifies that the response is valid and evaluates HTTP status codes before passing data to the decoding layer.

Successful responses continue through the decoding pipeline, while failures are converted into appropriate networking errors.

---

## 💉 Dependency Injection

BankingNetworkKit is designed around dependency injection and protocol abstractions.

Instead of tightly coupling feature code to a concrete networking implementation, dependencies can be provided from outside.

This makes the networking layer easier to replace, configure, and test.

---

## 🧪 Testability & Mocking

The networking architecture is designed with testing in mind.

Protocol abstractions allow real networking implementations to be replaced with mocks during unit tests.

This enables testing application behavior without making real network requests.

The package includes XCTest coverage for important networking components such as:

* Request creation
* HTTP methods
* Endpoint configuration
* Successful responses
* HTTP failures
* Invalid responses
* Decoding failures
* Mock API responses

---

## 🔐 Module Boundaries

BankingNetworkKit uses Swift access control to maintain clear module boundaries.

Only APIs required by package consumers are exposed as `public`.

Implementation details remain `internal` whenever possible.

```text
BankingDemoApp
      │
      │ Public API
      ▼
BankingNetworkKit
      │
      ├── Public interfaces
      │
      └── Internal implementation details
```

This keeps the public API small and prevents consumers from becoming dependent on internal implementation details.

---

## 📱 Example Usage

Import the package:

```swift
import BankingNetworkKit
```

Create or inject the networking client and perform requests using the package's public API.

```swift
let client = APIClient()

let account: Account = try await client.request(
    endpoint
)
```

Feature code only needs to understand the public networking interface rather than the underlying `URLSession`, request construction, validation, and decoding implementation.

---

## 🎓 Concepts to be Demonstrated

This repository demonstrates practical usage of:

* Swift Package Manager
* iOS modularization
* Swift module boundaries
* Access control
* Dependency management
* Protocol-oriented programming
* Dependency injection
* Generics
* Codable / Decodable
* URLSession
* URLRequest
* HTTP fundamentals
* Swift Concurrency
* async/await
* Error propagation
* Mocking
* XCTest
* Testable architecture

---

## 🎯 Project Goal

The goal of BankingNetworkKit is not simply to wrap `URLSession`.

It demonstrates how to design a networking layer as an independent module with clear responsibilities and boundaries.

The package provides a practical foundation for understanding how networking infrastructure can be structured in larger iOS applications such as banking, fintech, e-commerce, or other API-driven applications.

It also serves as a hands-on reference for Swift Package Manager, modular architecture, networking design, Swift Concurrency, dependency injection, and unit testing.
