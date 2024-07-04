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
            from: "1.16.2"
        ),

        .package(
            url: "https://github.com/sloik/EitherSwift.git",
            from: "1.2.0"
        ),
    ],

    targets: [

        .target(
            name: "FunctionalAPI",
            dependencies: [
                .product(name: "EitherSwift", package: "EitherSwift"),
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
