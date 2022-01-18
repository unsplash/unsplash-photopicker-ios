// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PixabayPhotoPicker",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "PixabayPhotoPicker",
            targets: ["PixabayPhotoPicker"]),
    ],
    targets: [
        .target(
            name: "PixabayPhotoPicker",
            dependencies: [],
            path: "PixabayPhotoPicker/PixabayPhotoPicker",
            exclude: ["Info.plist", "PixabayPhotoPicker.h"]
        )
    ]
)
