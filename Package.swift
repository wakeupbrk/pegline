// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Pegline",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(name: "Pegline", path: "Sources/Tendedero")
    ]
)
