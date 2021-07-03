// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ApplicationsController",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(name: "ApplicationsController", targets: ["ApplicationsController"]),
    ],
    targets: [
        .target(name: "ApplicationsController",dependencies: [])
    ]
)
