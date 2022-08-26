// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "DIKit",
    platforms: [
        .iOS(.v12),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "DIKit",
            targets: ["DIKit"]
        ),
    ],
    targets: [
        .target(
            name: "DIKit",
            path: "DIKit/Sources",
            exclude: [
                "Resources"
            ]
        ),
        .testTarget(
            name: "DIKitTests",
            dependencies: ["DIKit"],
            path: "DIKit/Tests",
            exclude: [
                "Info.plist"
            ]
        ),
    ]
)
