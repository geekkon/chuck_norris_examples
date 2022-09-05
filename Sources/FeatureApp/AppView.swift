import ComposableArchitecture
import FeatureCategories
import FeatureJoke
import FeatureUserSettings
import SwiftUI

public struct AppReducer: ReducerProtocol {

  public struct State: Equatable {

    public enum Tab: Equatable {
      case categories
      case joke
    }

    public var categories: Categories.State
    public var featureJoke: FeatureJoke.State
    public var selectedTab: Tab
    public var userSettings: UserSettings

    public init(
      categories: Categories.State = .init(),
      featureJoke: FeatureJoke.State = .init(),
      selectedTab: Tab = .categories,
      userSettings: UserSettings = .init()
    ) {
      self.categories = categories
      self.featureJoke = featureJoke
      self.selectedTab = selectedTab
      self.userSettings = userSettings
    }
  }

  public enum Action: Equatable {
    case appDelegate(AppDelegateReducer.Action)
    case featureCategories(Categories.Action)
    case featureJoke(FeatureJoke.Action)
    case selectTab(State.Tab)
  }

  public init() {}

  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.userSettings, action: /Action.appDelegate) {
      AppDelegateReducer()
    }
    Scope(state: \.categories, action: /Action.featureCategories) {
      Categories()
    }
    Scope(state: \.featureJoke, action: /Action.featureJoke) {
      FeatureJoke()
    }
    Reduce { state, action in
      switch action {
        case .appDelegate:
          return .none
        case .featureCategories:
          return .none
        case .featureJoke:
          return .none
        case let .selectTab(tab):
          state.selectedTab = tab
          return .none
      }
    }
  }
}

public struct AppView: View {

  private let store: StoreOf<AppReducer>
  @ObservedObject private var viewStore: ViewStore<ViewState, AppReducer.Action>

  struct ViewState: Equatable {
    let selectedTab: AppReducer.State.Tab

    init(state: AppReducer.State) {
      self.selectedTab = state.selectedTab
    }
  }

  public init(store: StoreOf<AppReducer>) {
    self.store = store
    self.viewStore = ViewStore(self.store.scope(state: ViewState.init))
  }
  
  public var body: some View {
    TabView(selection: viewStore.binding(get: \.selectedTab, send: { .selectTab($0) })) {
      CategoriesView(store: store.scope(state: \.categories, action: AppReducer.Action.featureCategories))
        .tag(AppReducer.State.Tab.categories)
        .tabItem(categoriesTabItem)
      JokeView(store: store.scope(state: \.featureJoke, action: AppReducer.Action.featureJoke))
        .tag(AppReducer.State.Tab.joke)
        .tabItem(jokeTabItem)
    }
  }

  @ViewBuilder
  private func categoriesTabItem() -> some View {
    Label("Categories", systemImage: "list.dash")
  }

  @ViewBuilder
  private func jokeTabItem() -> some View {
    Label("Random", systemImage: "star")
  }
}
