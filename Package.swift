// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Unsplash Photo Picker",
    platforms: [
        .iOS(.v11)
    ],
    products: [
    .library(name: "UnsplashPhotoPicker",
             targets: ["UnsplashPhotoPicker"])
    ],
    targets: [
    .target(
        name: "UnsplashPhotoPicker",
        path: "UnsplashPhotoPicker/UnsplashPhotoPicker")
    ]
)
