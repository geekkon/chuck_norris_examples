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
    .library(name: "SharedJokesRepository", targets: ["SharedJokesRepository"]),
    .library(name: "SharedModels", targets: ["SharedModels"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/kean/get",
      from: "2.0.0"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      branch: "protocol"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      from: "1.9.0"
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
      ],
      swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
    ),
    .testTarget(
      name: "FeatureAppTests",
      dependencies: [
        "FeatureApp",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: ["__Snapshots__"],
      swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
    ),
    .target(
      name: "FeatureCategories",
      dependencies: [
        "FeatureJoke",
        "SharedJokesRepository",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
    ),
    .testTarget(
      name: "FeatureCategoriesTests",
      dependencies: [
        "FeatureCategories",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: ["__Snapshots__"],
      swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
    ),
    .target(
      name: "FeatureJoke",
      dependencies: [
        "SharedJokesRepository",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
    ),
    .testTarget(
      name: "FeatureJokeTests",
      dependencies: [
        "FeatureJoke",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: ["__Snapshots__"],
      swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
    ),
    .target(
      name: "FeatureUserSettings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
    ),
    .target(
      name: "LibraryAPIClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Get", package: "get")
      ],
      swiftSettings: [.unsafeFlags(["-strict-concurrency=minimal"])]
    ),
    .target(
      name: "SharedJokesRepository",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "LibraryAPIClient"
      ],
      swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
    ),
    .target(
      name: "SharedModels",
      swiftSettings: [.unsafeFlags(["-strict-concurrency=complete"])]
    )
  ]
)
