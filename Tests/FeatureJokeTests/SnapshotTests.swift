//
//  Created by Nikita Borodulin on 09.09.2022.
//

import ComposableArchitecture
import Foundation
import SharedModels
import SnapshotTesting
import XCTest

@testable import FeatureJoke

@MainActor
final class SnapshotTests: XCTestCase {

  override func setUp() {
    super.setUp()
//    isRecording = true
  }

  func testLoading() {
    assertSnapshot(
      matching: JokeView(
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
      matching: JokeView(
        store: .init(
          initialState: .init(loadingState: .failed),
          reducer: EmptyReducer()
        )
      ),
      as: .image(layout: .device(config: .iPhoneXsMax))
    )
  }

  func testLoaded() {
    assertSnapshot(
      matching: JokeView(
        store: .init(
          initialState: .init(loadingState: .loaded(.mock)),
          reducer: EmptyReducer()
        )
      ),
      as: .image(layout: .device(config: .iPhoneXsMax))
    )
  }
}
