import ComposableArchitecture
import XCTest

@testable import FeatureJoke

@MainActor
final class FeatureJokeTests: XCTestCase {

  func testOnAppearTriggersRefreshInInitialState() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .initial
      ),
      reducer: FeatureJoke()
    )

    store.dependencies.jokesRepository.randomJoke = { _ in .mock }

    _ = await store.send(.onAppear) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }
  }

  func testOnAppearDoesntTriggerRefreshInNonInitialStates() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    )
    _ = await store.send(.onAppear)
  }

  func testRefresh() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    )

    store.dependencies.jokesRepository.randomJoke = { _ in .mock }

    _ = await store.send(.refreshTapped) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }
  }
}
