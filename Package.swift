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
        url: "https://github.com/pointfreeco/swift-dependencies",
        exact: "0.1.4"
    ),
    .package(
      url: "https://github.com/kean/get",
      exact: "2.1.6"
    ),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", revision: "8db9e20b0ad86ce6c4875e2f3928bc7b7c412bee"),
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      exact: "1.11.0"
    ),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", exact: "0.8.2")
  ],
  targets: [
    .target(
      name: "FeatureApp",
      dependencies: [
        .feature.categories,
        .feature.joke,
        .thirdParty.tca,
        .feature.userSettings
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
        .feature.joke,
        .shared.jokesRepository,
        .shared.models,
        .thirdParty.tca
      ]
    ),
    .testTarget(
      name: "FeatureCategoriesTests",
      dependencies: [
        .feature.categories,
        .thirdParty.snapshotTesting
      ],
      exclude: ["__Snapshots__"]
    ),
    .target(
      name: "FeatureJoke",
      dependencies: [
        .shared.analyticsClient,
        .shared.jokesRepository,
        .shared.models,
        .thirdParty.tca
      ]
    ),
    .testTarget(
      name: "FeatureJokeTests",
      dependencies: [
        .feature.joke,
        .thirdParty.snapshotTesting
      ],
      exclude: ["__Snapshots__"]
    ),
    .target(
      name: "FeatureUserSettings",
      dependencies: [
        .thirdParty.tca
      ]
    ),
    .target(
      name: "LibraryAPIClient",
      dependencies: [
        .thirdParty.get,
        .thirdParty.tca
      ]
    ),
    .target(
      name: "SharedJokesRepository",
      dependencies: [
        .library.apiClient,
        .thirdParty.tca
      ]
    ),
    .target(
      name: "SharedAnalyticsClient",
      dependencies: [
        .thirdParty.dependencies,
        .thirdParty.xcTestDynamicOverlay
      ]
    ),
    .target(
      name: "SharedAnalyticsClientLive",
      dependencies: [
        .shared.analyticsClient
      ]
    ),
    .target(
      name: "SharedModels"
    )
  ]
)

extension Target.Dependency {

  struct Feature {
    let categories = Target.Dependency.byNameItem(name: "FeatureCategories", condition: nil)
    let joke = Target.Dependency.byNameItem(name: "FeatureJoke", condition: nil)
    let userSettings = Target.Dependency.byNameItem(name: "FeatureUserSettings", condition: nil)
  }

  struct Library {
    let apiClient = Target.Dependency.byNameItem(name: "LibraryAPIClient", condition: nil)
  }

  struct Shared {
    let analyticsClient = Target.Dependency.byNameItem(name: "SharedAnalyticsClient", condition: nil)
    let jokesRepository = Target.Dependency.byNameItem(name: "SharedJokesRepository", condition: nil)
    let models = Target.Dependency.byNameItem(name: "SharedModels", condition: nil)
  }

  struct ThirdParty {
    let dependencies = Target.Dependency.product(name: "Dependencies", package: "swift-dependencies", condition: nil)
    let get = Target.Dependency.product(name: "Get", package: "get", condition: nil)
    let snapshotTesting = Target.Dependency.product(name: "SnapshotTesting", package: "swift-snapshot-testing", condition: nil)
    let tca = Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture", condition: nil)
    let xcTestDynamicOverlay = Target.Dependency.product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay", condition: nil)
  }

  static let feature = Feature()
  static let library = Library()
  static let shared = Shared()
  static let thirdParty = ThirdParty()
}
