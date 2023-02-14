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
    struct Failure: Error, Equatable {}
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    ) {
      $0.jokesRepository.randomJoke = { _ in throw Failure() }
    }

    await store.send(.refreshTapped) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.failure(Failure()))) {
      $0.loadingState = .failed
    }
  }

  func testSuccessfulRefresh() async {
    struct Failure: Error, Equatable {}
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    ) {
      $0.analyticsClient.track = { _ in }
      $0.jokesRepository.randomJoke = { _ in .mock }
      $0.mainQueue = DispatchQueue.test.eraseToAnyScheduler()
    }

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

    await store.send(.refreshTapped)
  }

  func testRefreshCancelsTimer() async {
    let jokeLoading = AsyncThrowingStream<Joke, Error>.streamWithContinuation()
    let mainQueue = DispatchQueue.test
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    ) {
      $0.jokesRepository.randomJoke = { _ in try await jokeLoading.stream.first { _ in true }! }
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }

    await store.send(.refreshTapped) {
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

