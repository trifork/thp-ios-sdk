// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TriforkHealthPlatformSDK",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TriforkHealthPlatformSDK",
            targets: ["TriforkHealthPlatformSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/trifork/TIM-iOS", from: "2.9.2"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.0.5")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TriforkHealthPlatformSDK",
            dependencies: [
                .product(name: "TIM", package: "TIM-iOS"),
                .product(name: "Apollo", package: "apollo-ios")
            ]
        ),
        .testTarget(
            name: "TriforkHealthPlatformSDKTests",
            dependencies: [
                "TriforkHealthPlatformSDK"
            ]
        ),
    ]
)
