//
//  Created by Nikita Borodulin on 06.09.2022.
//

import ComposableArchitecture
import SharedJokesRepository
import SharedModels
import SwiftUI

public struct LoadingCategories: Reducer {

  public struct State: Equatable {

    public var hasInFlightRequest: Bool

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

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
      case .delegate(.categoriesLoaded):
        state.hasInFlightRequest = false
        return .none
      case .onAppear:
        if state.hasInFlightRequest {
          return .none
        }
        state.hasInFlightRequest = true
        return .task { [repository = jokesRepository] in
          await .delegate(.categoriesLoaded(TaskResult { try await repository.categories() }))
        }
    }
  }
}

struct LoadingCategoriesView: View {

  let store: StoreOf<LoadingCategories>

  var body: some View {
    ProgressView()
      .onAppear {
        ViewStore(store, observe: { $0 }).send(.onAppear)
      }
  }
}
