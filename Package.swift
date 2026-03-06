// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GuardianCircle",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "GuardianCircle",
            targets: ["GuardianCircle"]),
    ],
    dependencies: [
        .package(url: "https://github.com/argentlabs/web3.swift", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "GuardianCircle",
            dependencies: [
                .product(name: "web3", package: "web3.swift")
            ],
            path: "GuardianCircle")
    ]
)
