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

    public var featureCategories: FeatureCategories.State
    public var featureJoke: FeatureJoke.State
    public var selectedTab: Tab
    public var userSettings: UserSettings

    public init(
      categories: FeatureCategories.State = .init(),
      featureJoke: FeatureJoke.State = .init(),
      selectedTab: Tab = .categories,
      userSettings: UserSettings = .init()
    ) {
      self.featureCategories = categories
      self.featureJoke = featureJoke
      self.selectedTab = selectedTab
      self.userSettings = userSettings
    }
  }

  public enum Action: Equatable {
    case appDelegate(AppDelegateReducer.Action)
    case featureCategories(FeatureCategories.Action)
    case featureJoke(FeatureJoke.Action)
    case selectTab(State.Tab)
  }

  public init() {}

  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.userSettings, action: /Action.appDelegate) {
      AppDelegateReducer()
    }
    Scope(state: \.featureCategories, action: /Action.featureCategories) {
      FeatureCategories()
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

  struct ViewState: Equatable {
    let selectedTab: AppReducer.State.Tab

    init(state: AppReducer.State) {
      self.selectedTab = state.selectedTab
    }
  }

  public init(store: StoreOf<AppReducer>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      TabView(selection: viewStore.binding(get: \.selectedTab, send: { .selectTab($0) })) {
        categoriesView
        jokeView
      }
    }
  }

  private var categoriesView: some View {
    NavigationView {
      CategoriesView(store: store.scope(state: \.featureCategories, action: AppReducer.Action.featureCategories))
        .navigationTitle("Joke Categories")
    }
    .navigationViewStyle(.stack)
    .tag(AppReducer.State.Tab.categories)
    .tabItem { categoriesTabItem() }
  }

  private var jokeView: some View {
    NavigationView {
      JokeView(store: store.scope(state: \.featureJoke, action: AppReducer.Action.featureJoke))
    }
    .navigationViewStyle(.stack)
    .tag(AppReducer.State.Tab.joke)
    .tabItem { jokeTabItem() }
  }

  private func categoriesTabItem() -> some View {
    Label("Categories", systemImage: "list.dash")
  }

  private func jokeTabItem() -> some View {
    Label("Random", systemImage: "star")
  }
}

struct AppView_Previews: PreviewProvider {

  static var previews: some View {
    NavigationView {
      AppView(
        store: .init(
          initialState: AppReducer.State(),
          reducer: AppReducer()
        )
      )
    }
  }
}
