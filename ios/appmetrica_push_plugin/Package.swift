// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "appmetrica_push_plugin",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        .library(name: "appmetrica-push-plugin", targets: ["appmetrica_push_plugin"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/appmetrica/push-sdk-ios",
            .upToNextMajor(from: "3.1.0")
        ),
        .package(
            path: "appmetrica_plugin"
        )
    ],
    targets: [
        .target(
            name: "appmetrica_push_plugin",
            dependencies: [
                .product(name: "AppMetricaPush", package: "push-sdk-ios"),
                .product(name: "appmetrica-plugin", package: "appmetrica_plugin")
            ],
            resources: [],
            cSettings: [
                .headerSearchPath("include/appmetrica_push_plugin")
            ]
        )
    ]
)
