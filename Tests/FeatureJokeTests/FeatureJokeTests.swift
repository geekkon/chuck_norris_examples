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
    ) {
      $0.analyticsClient.track = { _ in }
      $0.jokesRepository.randomJoke = { _ in .mock }
      $0.mainQueue = DispatchQueue.test.eraseToAnyScheduler()
    }

    let task = await store.send(.onAppear) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }

    await task.cancel()
  }

  func testOnAppearDoesntTriggerRefreshInNonInitialStates() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    ) {
      $0.mainQueue = DispatchQueue.test.eraseToAnyScheduler()
    }
    let task = await store.send(.onAppear)
    await task.cancel()
  }

  func testOnDisappearCancelsInFlightRequest() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .initial
      ),
      reducer: FeatureJoke()
    ) {
      $0.jokesRepository.randomJoke = { _ in try await Task.never() }
    }

    await store.send(.onAppear) {
      $0.loadingState = .loading
    }
    await store.send(.onDisappear) {
      $0.loadingState = .initial
    }
  }
}
