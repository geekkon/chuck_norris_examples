//
//  Created by Nikita Borodulin on 03.10.2022.
//

import ComposableArchitecture
import SharedAnalytics
import XCTest

@testable import FeatureJoke

@MainActor
final class AnalyticsTests: XCTestCase {

  func testJokeLoadedTracked() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loading
      ),
      reducer: FeatureJoke()
    )

    var trackedEvent: Event?
    store.dependencies.analyticsClient.track = { @MainActor in
      trackedEvent = $0
    }
    store.dependencies.jokesRepository.randomJoke = { _ in .mock }
    store.dependencies.mainQueue = DispatchQueue.test.eraseToAnyScheduler()

    let task = await store.send(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }

    XCTAssertNotNil(trackedEvent)

    await task.cancel()
  }
}
