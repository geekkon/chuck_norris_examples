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

    _ = await store.send(.loading(.onAppear)) {
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

    _ = await store.send(.loading(.onAppear))
    _ = await store.send(.loading(.onAppear))

    await task.cancel()
  }

  func testLoadingFailureSetsFailedState() async {
    let store = TestStore(
      initialState: FeatureCategories.State(),
      reducer: FeatureCategories()
    )

    struct Failure: Error, Equatable {}
    store.dependencies.jokesRepository.categories = { throw Failure() }

    _ = await store.send(.loading(.onAppear)) {
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

    _ = await store.send(.loading(.onAppear)) {
      $0.loadingState = .loading(.init(hasInFlightRequest: true))
    }

    await store.receive(.loading(.delegate(.categoriesLoaded(.failure(Failure()))))) {
      $0.loadingState = .failed()
    }

    store.dependencies.jokesRepository.categories = { [] }

    _ = await store.send(.failed(.retry)) {
      $0.loadingState = .loading(.init(hasInFlightRequest: false))
    }

    _ = await store.send(.loading(.onAppear)) {
      $0.loadingState = .loading(.init(hasInFlightRequest: true))
    }

    await store.receive(.loading(.delegate(.categoriesLoaded(.success([]))))) {
      $0.loadingState = .loaded()
    }
  }

  func testSelectionTriggersNavigation() async {
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

    _ = await store.send(
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
              selection: .init(.init(category: .mock), id: .mock)
            )
          ]
        )
      )
    }
  }

  func testPoppingJokeClearsSelection() async {
    let store = TestStore(
      initialState: FeatureCategories.State(
        loadingState: .loaded(
          .init(
            categories: [
              .init(
                category: .mock,
                selection: .init(.init(category: .mock), id: .mock)
              )
            ]
          )
        )
      ),
      reducer: FeatureCategories()
    )

    _ = await store.send(
      .loaded(
        .category(
          id: JokeCategory.mock.id,
          action: .joke(.onDisappear)
        )
      )
    ) {
      $0.loadingState = .loaded(
        .init(
          categories: [
            .init(
              category: .mock,
              selection: nil
            )
          ]
        )
      )
    }
  }
}
