// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactSwiftUI",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "ReactSwiftUI",
            targets: ["ReactSwiftUI"]),
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    targets: [
        .target(
            name: "ReactSwiftUI",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "ReactSwiftUITests",
            dependencies: ["ReactSwiftUI"]),
        .target(
            name: "Core",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),
    ]
)
