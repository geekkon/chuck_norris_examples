//
//  Created by Nikita Borodulin on 07.09.2022.
//

import ComposableArchitecture
import XCTest

@testable import FeatureJoke

@MainActor
final class RefreshTests: XCTestCase {

  func testFailedRefresh() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    )

    struct Failure: Error, Equatable {}
    store.dependencies.jokesRepository.randomJoke = { _ in throw Failure() }

    _ = await store.send(.refreshTapped) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.failure(Failure()))) {
      $0.loadingState = .failed
    }
  }

  func testSuccessfulRefresh() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    )

    struct Failure: Error, Equatable {}
    store.dependencies.jokesRepository.randomJoke = { _ in .mock }

    _ = await store.send(.refreshTapped) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }
  }

  func testRefreshTapHasNoEffectIfAlreadyLoading() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loading
      ),
      reducer: FeatureJoke()
    )

    _ = await store.send(.refreshTapped)
  }
}

