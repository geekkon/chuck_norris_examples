import ComposableArchitecture
import SharedModels
import SwiftUI

public struct FeatureCategories: ReducerProtocol {

  public struct State: Equatable {

    public enum LoadingState: Equatable {
      case failed(FailedCategories.State = .init())
      case loaded(LoadedCategories.State = .init(categories: []))
      case loading(LoadingCategories.State = .init())
    }

    var loadingState: LoadingState

    public init(
      loadingState: LoadingState = .loading()
    ) {
      self.loadingState = loadingState
    }
  }

  public enum Action: Equatable {
    case failed(FailedCategories.Action)
    case loaded(LoadedCategories.Action)
    case loading(LoadingCategories.Action)
  }

  public init() {}

  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.loadingState, action: .self) {
      EmptyReducer()
        .ifCaseLet(/State.LoadingState.failed, action: /Action.failed) {
          FailedCategories()
        }
        .ifCaseLet(/State.LoadingState.loaded, action: /Action.loaded) {
          LoadedCategories()
        }
        .ifCaseLet(/State.LoadingState.loading, action: /Action.loading) {
          LoadingCategories()
        }
    }

    Reduce { state, action in
      switch action {
        case .failed(.retry):
          state.loadingState = .loading(.init())
          return .none
        case .loaded:
          return .none
        case let .loading(.delegate(.categoriesLoaded(.success(categories)))):
          let categoryRowStates = categories.map( { CategoryRow.State(category: $0) })
          state.loadingState = .loaded(
            .init(categories: .init(uniqueElements: categoryRowStates))
          )
          return .none
        case .loading(.delegate(.categoriesLoaded(.failure))):
          state.loadingState = .failed()
          return .none
        case .loading:
          return .none
      }
    }
  }
}

public struct CategoriesView: View {

  let store: StoreOf<FeatureCategories>

  public init(store: StoreOf<FeatureCategories>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.loadingState)) {
      CaseLet(
        state: /FeatureCategories.State.LoadingState.loading,
        action: FeatureCategories.Action.loading,
        then: LoadingCategoriesView.init
      )
      CaseLet(
        state: /FeatureCategories.State.LoadingState.failed,
        action: FeatureCategories.Action.failed,
        then: FailedCategoriesView.init
      )
      CaseLet(
        state: /FeatureCategories.State.LoadingState.loaded,
        action: FeatureCategories.Action.loaded,
        then: LoadedCategoriesView.init
      )
    }
  }
}

struct CategoriesView_Previews: PreviewProvider {

  static var previews: some View {
    NavigationView {
      CategoriesView(
        store: .init(
          initialState: .init(),
          reducer: FeatureCategories()
        )
      )
    }
  }
}
