// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VeTOSiOSSDK",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "VeTOSiOSSDK",
            targets: ["VeTOSiOSSDK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "VeTOSiOSSDK",
            path: "VeTOSiOSSDK.xcframework"
        )
    ]
)
