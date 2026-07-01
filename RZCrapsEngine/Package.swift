// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "RZCrapsEngine",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "RZCrapsEngine",
            targets: ["RZCrapsEngine"]
        )
    ],
    targets: [
        .target(
            name: "RZCrapsEngine",
            path: "Sources/RZCrapsEngine"
        ),
        .testTarget(
            name: "RZCrapsEngineTests",
            dependencies: ["RZCrapsEngine"],
            path: "Tests/RZCrapsEngineTests"
        )
    ]
)

