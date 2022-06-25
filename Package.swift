// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "RatingControl",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(name: "RatingControl", targets: ["RatingControl"]),
    ],
    targets: [
        .target(name: "RatingControl"),
        .testTarget(name: "RatingControlTests", dependencies: ["RatingControl"]),
    ]
)
