//
//  Created by Nikita Borodulin on 06.09.2022.
//

import ComposableArchitecture
import SharedJokesRepository
import SharedModels
import SwiftUI

public struct LoadingCategories: ReducerProtocol {

  public struct State: Equatable {

    var hasInFlightRequest: Bool

    public init(hasInFlightRequest: Bool = false) {
      self.hasInFlightRequest = hasInFlightRequest
    }
  }

  public enum Action: Equatable {

    public enum DelegateAction: Equatable {
      case categoriesLoaded(TaskResult<[JokeCategory]>)
    }

    case delegate(DelegateAction)
    case onAppear
  }

  @Dependency(\.jokesRepository) var jokesRepository

  public init() {}

  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
      case .delegate(.categoriesLoaded):
        state.hasInFlightRequest = false
        return .none
      case .onAppear:
        if state.hasInFlightRequest {
          return .none
        }
        state.hasInFlightRequest = true
        return .task {
          await .delegate(.categoriesLoaded(TaskResult { try await jokesRepository.categories() }))
        }
    }
  }
}

struct LoadingCategoriesView: View {

  let store: StoreOf<LoadingCategories>

  var body: some View {
    WithViewStore(store) { viewStore in
      ProgressView()
        .onAppear {
          viewStore.send(.onAppear)
        }
    }
  }
}
