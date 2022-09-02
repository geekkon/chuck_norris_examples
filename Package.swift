// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "TCAChuckNorris",
  platforms: [
    .iOS(.v13),
    .macOS(.v12),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
    .library(name: "FeatureApp", targets: ["FeatureApp"]),
    .library(name: "FeatureCategories", targets: ["FeatureCategories"]),
    .library(name: "FeatureJoke", targets: ["FeatureJoke"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      branch: "protocol"
    )
  ],
  targets: [
    .target(
      name: "FeatureApp",
      dependencies: [
        "FeatureCategories",
        "FeatureJoke",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "FeatureCategories",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "FeatureCategoriesTests",
      dependencies: [
        "FeatureCategories"
      ]
    ),
    .target(
      name: "FeatureJoke",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "FeatureJokeTests",
      dependencies: [
        "FeatureJoke"
      ]
    )
  ]
)
