//
//  Created by Nikita Borodulin on 03.10.2022.
//

import ComposableArchitecture
import SharedAnalyticsClient
import XCTest

@testable import FeatureJoke

@MainActor
final class AnalyticsTests: XCTestCase {

  func testJokeLoadedTracked() async {
    var trackedEvent: Event?
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loading
      ),
      reducer: FeatureJoke()
    ) {
      $0.analyticsClient.track = { @MainActor in
        trackedEvent = $0
      }
      $0.jokesRepository.randomJoke = { _ in .mock }
      $0.mainQueue = DispatchQueue.test.eraseToAnyScheduler()
    }

    let task = await store.send(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }

    XCTAssertNotNil(trackedEvent)

    await task.cancel()
  }
}
