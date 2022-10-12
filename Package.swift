// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "TCAChuckNorris",
  platforms: [
    .iOS(.v14),
    .macOS(.v12),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
    .library(name: "FeatureApp", targets: ["FeatureApp"]),
    .library(name: "FeatureCategories", targets: ["FeatureCategories"]),
    .library(name: "FeatureJoke", targets: ["FeatureJoke"]),
    .library(name: "FeatureUserSettings", targets: ["FeatureUserSettings"]),
    .library(name: "LibraryAPIClient", targets: ["LibraryAPIClient"]),
    .library(name: "SharedAnalyticsClientLive", targets: ["SharedAnalyticsClientLive"]),
    .library(name: "SharedJokesRepository", targets: ["SharedJokesRepository"]),
    .library(name: "SharedModels", targets: ["SharedModels"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/kean/get",
      from: "2.0.0"
    ),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.41.0"),
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      from: "1.10.0"
    ),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.2.0")
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
    .testTarget(
      name: "FeatureAppTests",
      dependencies: [
        "FeatureApp",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: ["__Snapshots__"]
    ),
    .target(
      name: "FeatureCategories",
      dependencies: [
        "FeatureJoke",
        "SharedJokesRepository",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "FeatureCategoriesTests",
      dependencies: [
        "FeatureCategories",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: ["__Snapshots__"]
    ),
    .target(
      name: "FeatureJoke",
      dependencies: [
        "SharedAnalyticsClient",
        "SharedJokesRepository",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "FeatureJokeTests",
      dependencies: [
        "FeatureJoke",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: ["__Snapshots__"]
    ),
    .target(
      name: "FeatureUserSettings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "LibraryAPIClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Get", package: "get")
      ]
    ),
    .target(
      name: "SharedJokesRepository",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "LibraryAPIClient"
      ]
    ),
    .target(
      name: "SharedAnalyticsClient",
      dependencies: [
        .product(name: "Dependencies", package: "swift-composable-architecture"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ]
    ),
    .target(
      name: "SharedAnalyticsClientLive",
      dependencies: [
        "SharedAnalyticsClient"
      ]
    ),
    .target(
      name: "SharedModels"
    )
  ]
)
