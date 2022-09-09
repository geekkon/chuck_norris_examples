import ComposableArchitecture
import SharedModels
import XCTest

@testable import FeatureCategories

@MainActor
final class FeatureCategoriesTests: XCTestCase {

  func testCategoriesLoadsOnAppear() async {
    let store = TestStore(
      initialState: FeatureCategories.State(),
      reducer: FeatureCategories()
    )

    store.dependencies.jokesRepository.categories = { [] }

    await store.send(.loading(.onAppear)) {
      $0.loadingState = .loading(.init(hasInFlightRequest: true))
    }

    await store.receive(.loading(.delegate(.categoriesLoaded(.success([]))))) {
      $0.loadingState = .loaded(.init())
    }
  }

  func testRepeatedOnAppearDoesntTriggerRepeatedRequests() async {
    let store = TestStore(
      initialState: FeatureCategories.State(),
      reducer: FeatureCategories()
    )

    store.dependencies.jokesRepository.categories = { try await Task.never() }

    let task = await store.send(.loading(.onAppear)) {
      $0.loadingState = .loading(.init(hasInFlightRequest: true))
    }

    await store.send(.loading(.onAppear))
    await store.send(.loading(.onAppear))

    await task.cancel()
  }

  func testLoadingFailureSetsFailedState() async {
    let store = TestStore(
      initialState: FeatureCategories.State(),
      reducer: FeatureCategories()
    )

    struct Failure: Error, Equatable {}
    store.dependencies.jokesRepository.categories = { throw Failure() }

    await store.send(.loading(.onAppear)) {
      $0.loadingState = .loading(.init(hasInFlightRequest: true))
    }

    await store.receive(.loading(.delegate(.categoriesLoaded(.failure(Failure()))))) {
      $0.loadingState = .failed()
    }
  }

  func testRetry() async {
    let store = TestStore(
      initialState: FeatureCategories.State(),
      reducer: FeatureCategories()
    )

    struct Failure: Error, Equatable {}
    store.dependencies.jokesRepository.categories = { throw Failure() }

    await store.send(.loading(.onAppear)) {
      $0.loadingState = .loading(.init(hasInFlightRequest: true))
    }

    await store.receive(.loading(.delegate(.categoriesLoaded(.failure(Failure()))))) {
      $0.loadingState = .failed()
    }

    store.dependencies.jokesRepository.categories = { [] }

    await store.send(.failed(.retry)) {
      $0.loadingState = .loading(.init(hasInFlightRequest: false))
    }

    await store.send(.loading(.onAppear)) {
      $0.loadingState = .loading(.init(hasInFlightRequest: true))
    }

    await store.receive(.loading(.delegate(.categoriesLoaded(.success([]))))) {
      $0.loadingState = .loaded()
    }
  }

  func testSelectiomTriggersNavigation() async {
    let store = TestStore(
      initialState: FeatureCategories.State(
        loadingState: .loaded(
          .init(
            categories: [.init(category: .mock)]
          )
        )
      ),
      reducer: FeatureCategories()
    )

    await store.send(
      .loaded(
        .category(
          id: JokeCategory.mock.id,
          action: .setNavigation(selection: .mock)
        )
      )
    ) {
      $0.loadingState = .loaded(
        .init(
          categories: [
            .init(
              category: .mock,
              selection: .init(.init(category: .mock), id: JokeCategory.mock)
            )
          ]
        )
      )
    }
  }
}
