//
//  Created by Nikita Borodulin on 30.09.2022.
//

import ComposableArchitecture
import XCTest

@testable import FeatureApp

@MainActor
final class FeatureAppTests: XCTestCase {

  func testTabSelection() async {
    let store = TestStore(
      initialState: AppReducer.State(selectedTab: .categories),
      reducer: AppReducer()
    )

    await store.send(.selectTab(.categories))

    await store.send(.selectTab(.joke)) {
      $0.selectedTab = .joke
    }
  }
}
