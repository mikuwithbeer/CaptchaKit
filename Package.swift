// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CaptchaKit",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "CaptchaKit", targets: ["CaptchaKit"])
    ],
    targets: [
        .target(name: "CaptchaKit"),
        .testTarget(
            name: "CaptchaKitTests",
            dependencies: ["CaptchaKit"]
        ),
    ]
)
