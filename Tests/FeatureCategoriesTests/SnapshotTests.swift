//
//  Created by Nikita Borodulin on 09.09.2022.
//

import ComposableArchitecture
import Foundation
import SharedModels
import SnapshotTesting
import SwiftUI
import XCTest

@testable import FeatureCategories

final class SnapshotTests: XCTestCase {

  override func setUp() {
    super.setUp()
//    isRecording = true
  }

  func testLoading() {
    assertSnapshot(
      matching: CategoriesView(
        store: .init(
          initialState: .init(),
          reducer: EmptyReducer()
        )
      ),
      as: .image(layout: .device(config: .iPhoneXsMax))
    )
  }

  func testFailed() {
    assertSnapshot(
      matching: CategoriesView(
        store: .init(
          initialState: .init(loadingState: .failed()),
          reducer: EmptyReducer()
        )
      ),
      as: .image(layout: .device(config: .iPhoneXsMax))
    )
  }

  func testLoaded() {
    assertSnapshot(
      matching: CategoriesView(
        store: .init(
          initialState: .init(
            loadingState: .loaded(
              .init(categories: [.init(category: .mock), .init(category: .init("KEK"))]))
          ),
          reducer: EmptyReducer()
        )
      ),
      as: .image(layout: .device(config: .iPhoneXsMax))
    )
  }
}
