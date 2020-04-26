// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlockchainExchangeKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .executable(name: "examples", targets: ["BlockchainExchangeExamples"]),
        .library(
            name: "BlockchainExchangeKit",
            targets: ["BlockchainExchangeKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.0"),
        .package(
            url: "https://github.com/Flight-School/AnyCodable",
            from: "0.2.3"
        ),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "BlockchainExchangeExamples",
            dependencies: ["BlockchainExchangeKit", .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .target(
            name: "BlockchainExchangeKit",
            dependencies: ["Starscream", "AnyCodable"]),
        .testTarget(
            name: "BlockchainExchangeKitTests",
            dependencies: ["BlockchainExchangeKit"]),
    ]
)
