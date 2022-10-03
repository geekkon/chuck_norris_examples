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
    store.dependencies.mainQueue = DispatchQueue.test.eraseToAnyScheduler()

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
    )
    store.dependencies.mainQueue = DispatchQueue.test.eraseToAnyScheduler()
    let task = await store.send(.onAppear)
    await task.cancel()
  }

  func testOnDisappearCancelsInFlightRequest() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .initial
      ),
      reducer: FeatureJoke()
    )
    store.dependencies.jokesRepository.randomJoke = { _ in try await Task.never() }

    _ = await store.send(.onAppear) {
      $0.loadingState = .loading
    }
    _ = await store.send(.onDisappear) {
      $0.loadingState = .initial
    }
  }
}
