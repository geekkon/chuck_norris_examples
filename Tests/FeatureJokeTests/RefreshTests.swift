//
//  Created by Nikita Borodulin on 07.09.2022.
//

import ComposableArchitecture
import SharedModels
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
    store.dependencies.mainQueue = DispatchQueue.test.eraseToAnyScheduler()

    let task = await store.send(.refreshTapped) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }

    await task.cancel()
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

  func testRefreshCancelsTimer() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    )

    let mainQueue = DispatchQueue.test
    store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()

    let jokeLoading = AsyncThrowingStream<Joke, Error>.streamWithContinuation()
    store.dependencies.jokesRepository.randomJoke = { _ in try await jokeLoading.stream.first { _ in true }! }

    _ = await store.send(.refreshTapped) {
      $0.loadingState = .loading
    }

    await mainQueue.advance(by: .seconds(5))

    struct Failure: Error, Equatable {}
    jokeLoading.continuation.finish(throwing: Failure())

    await store.receive(.jokeLoaded(.failure(Failure()))) {
      $0.loadingState = .failed
    }
  }
}

