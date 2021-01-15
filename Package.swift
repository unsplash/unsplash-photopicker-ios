// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnsplashPhotoPicker",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "UnsplashPhotoPicker",
            targets: ["UnsplashPhotoPicker"]),
    ],
    targets: [
        .target(
            name: "UnsplashPhotoPicker",
            dependencies: [],
            path: "UnsplashPhotoPicker/UnsplashPhotoPicker",
            exclude: ["Info.plist", "UnsplashPhotoPicker.h"]
        )
    ]
)
