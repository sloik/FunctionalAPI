// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FunctionalAPI",

    platforms: [
        .macOS(.v10_13),
        .iOS(.v14),
        .tvOS(.v11),
        .watchOS(.v4)
    ],

    products: [
        .library(
            name: "FunctionalAPI",
            type: .dynamic,
            targets: ["FunctionalAPI"]
        ),
    ],

    dependencies: [
        .package(
          url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
          from: "1.9.0"
        ),

        .package(
          url: "https://github.com/sloik/AliasWonderland.git",
          from: "0.0.1"
        ),

        .package(
            url: "https://github.com/sloik/OptionalAPI.git",
            from: "3.0.2"
        ),
    ],

    targets: [

        .target(
            name: "FunctionalAPI",
            dependencies: [
                .product(name: "OptionalAPI", package: "OptionalAPI"),
            ]
        ),

        .testTarget(
            name: "FunctionalAPITests",
            dependencies: [
                "FunctionalAPI",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),

            ]
        ),
    ]
)
