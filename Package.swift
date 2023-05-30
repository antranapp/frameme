// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "frameme",
    platforms: [
        // Only macOS because of the difference in CoreGraphics between macOS and iOS.
        //
        // This would be trivial to modify so it worked on iOS platforms.
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "FrameMeCore",
            targets: ["FrameMeCore"]
        ),
        .executable(
            name: "frameme",
            targets: ["frameme"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2")
    ],
    targets: [
        .target(
            name: "FrameMeCore",
            dependencies: []
        ),
        
        .executableTarget(
            name: "frameme",
            dependencies: [
                "FrameMeCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        
        .testTarget(
            name: "FrameMeCoreTests",
            dependencies: ["FrameMeCore"],
            resources: [
              // Resources for tests.
              .copy("Resources")
            ]
        )
    ]
)
