// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "my-copy-tweak",
    dependencies: [
    ],
    targets: [
        .target(
            name: "my-copy-tweak",
            dependencies: []),
        .testTarget(
            name: "my-copy-tweakTests",
            dependencies: ["my-copy-tweak"]),
    ]
)
