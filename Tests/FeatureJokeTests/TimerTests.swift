//
//  Created by Nikita Borodulin on 02.10.2022.
//

import ComposableArchitecture
import XCTest

@testable import FeatureJoke

@MainActor
final class TimerTests: XCTestCase {

  func testTimerHappyPath() async {
    let mainQueue = DispatchQueue.test
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .initial
      ),
      reducer: FeatureJoke()
    ) {
      $0.analyticsClient.track = { _ in }
      $0.jokesRepository.randomJoke = { _ in .mock }
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }

    await store.send(.onAppear) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }

    await mainQueue.advance(by: .seconds(1))
    await mainQueue.advance(by: .seconds(1))
    await mainQueue.advance(by: .seconds(1))

    await store.receive(.timerTicked) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }

    await mainQueue.advance(by: .seconds(1))
    await store.send(.onDisappear)
  }

  func testTimerRequestFailed() async {
    let mainQueue = DispatchQueue.test
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .initial
      ),
      reducer: FeatureJoke()
    ) {
      $0.analyticsClient.track = { _ in }
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }

    store.dependencies.jokesRepository.randomJoke = { _ in .mock }

    await store.send(.onAppear) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }

    struct Failure: Error, Equatable {}
    store.dependencies.jokesRepository.randomJoke = { _ in throw Failure() }

    await mainQueue.advance(by: .seconds(3))

    await store.receive(.timerTicked) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.failure(Failure()))) {
      $0.loadingState = .failed
    }
  }

  func testTimerStartsOnAppearIfJokeIsLoaded() async {
    struct Failure: Error, Equatable {}
    let mainQueue = DispatchQueue.test
    let store = TestStore(
      initialState: FeatureJoke.State(
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    ) {
      $0.jokesRepository.randomJoke = { _ in throw Failure() }
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    }

    await store.send(.onAppear)

    await mainQueue.advance(by: .seconds(3))

    await store.receive(.timerTicked) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.failure(Failure()))) {
      $0.loadingState = .failed
    }
  }

  func testTimerDoesntStartIfCategoryIsSelected() async {
    let store = TestStore(
      initialState: FeatureJoke.State(
        category: .mock,
        loadingState: .loaded(.mock)
      ),
      reducer: FeatureJoke()
    ) {
      $0.analyticsClient.track = { _ in }
      $0.jokesRepository.randomJoke = { _ in .mock }
    }

    await store.send(.onAppear)

    await store.send(.refreshTapped) {
      $0.loadingState = .loading
    }

    await store.receive(.jokeLoaded(.success(.mock))) {
      $0.loadingState = .loaded(.mock)
    }
  }
}
