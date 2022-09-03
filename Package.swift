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
    .library(name: "FeatureJoke", targets: ["FeatureJoke"]),
    .library(name: "FeatureUserSettings", targets: ["FeatureUserSettings"]),
    .library(name: "SharedJokesRepository", targets: ["SharedJokesRepository"]),
    .library(name: "SharedModels", targets: ["SharedModels"]),
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
        "FeatureUserSettings",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "FeatureCategories",
      dependencies: [
        "SharedModels",
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
        "SharedJokesRepository",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "FeatureJokeTests",
      dependencies: [
        "FeatureJoke"
      ]
    ),
    .target(
      name: "FeatureUserSettings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "SharedJokesRepository",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "SharedModels"
    )
  ]
)
