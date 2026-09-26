// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BankingNetworkKit",
    
    platforms: [
        .iOS(.v15)
    ],
    
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BankingNetworkKit",
            targets: ["BankingNetworkKit"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BankingNetworkKit",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "BankingNetworkKitTests",
            dependencies: ["BankingNetworkKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ]
)

/*
 
 BankingNetworkKit
        │
      PACKAGE
        │
┌─────────┴─────────┐
│                   │
PRODUCT             TARGETS
│                   │
BankingNetworkKit       ┌─────┴─────────────┐
│             │                   │
└──────→ BankingNetworkKit   BankingNetworkKitTests
           Target               Target
             │                    │
             ↓                    │
           Module ←───────────────┘
                      depends on
 
*/
