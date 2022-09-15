//
//  Created by Nikita Borodulin on 09.09.2022.
//

import ComposableArchitecture
import FeatureCategories
import FeatureJoke
import Foundation
import SharedModels
import SnapshotTesting
import XCTest

@testable import FeatureApp

@MainActor
final class SnapshotTests: XCTestCase {

  override func setUp() {
    super.setUp()
//    isRecording = true
  }

  func testFirstTabSelected() {
    assertSnapshot(
      matching: AppView(
        store: .init(
          initialState: .init(
            categories: .init(loadingState: .loaded(.init(categories: [.init(category: .mock)]))),
            selectedTab: .categories),
          reducer: EmptyReducer()
        )
      ),
      as: .image(layout: .device(config: .iPhoneXsMax))
    )
  }

  func testSecondTabSelected() {
    assertSnapshot(
      matching: AppView(
        store: .init(
          initialState: .init(
            featureJoke: .init(loadingState: .loaded(.mock)),
            selectedTab: .joke
          ),
          reducer: EmptyReducer()
        )
      ),
      as: .image(layout: .device(config: .iPhoneXsMax))
    )
  }
}
