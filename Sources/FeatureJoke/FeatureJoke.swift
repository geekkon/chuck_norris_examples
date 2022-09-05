import ComposableArchitecture
import SharedJokesRepository
import SharedModels
import SwiftUI

public struct FeatureJoke: ReducerProtocol {

  public struct State: Equatable {

    public enum LoadingState: Equatable {
      case failed
      case loading
      case loaded(Joke)
    }

    let category: JokeCategory?
    var loadingState: LoadingState

    public init(
      category: JokeCategory? = nil,
      loadingState: LoadingState = .loading
    ) {
      self.category = category
      self.loadingState = loadingState
    }
  }

  public enum Action: Equatable {
    case jokeLoaded(TaskResult<Joke>)

    @available(iOS, deprecated: 15.0, message: ".task() modifier should be used instead")
    case onAppear
    @available(iOS, deprecated: 15.0, message: ".task() modifier should be used instead")
    case onDisappear

    case refreshTapped
    case task
  }

  private enum CancelID {}

  @Dependency(\.jokesRepository) var jokesRepository

  public init() {}

  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
      case .jokeLoaded(.failure):
        state.loadingState = .failed
        return .none
      case let .jokeLoaded(.success(joke)):
        state.loadingState = .loaded(joke)
        return .none
      case .onAppear:
        return loadJoke(state: &state)
      case .onDisappear:
        return .cancel(id: CancelID.self)
      case .refreshTapped:
        return loadJoke(state: &state)
      case .task:
        return loadJoke(state: &state)
    }
  }

  private func loadJoke(state: inout State) -> Effect<Action, Never> {
    state.loadingState = .loading
    return .task { [state] in
      await .jokeLoaded(TaskResult { try await jokesRepository.randomJoke(state.category) })
    }
    .animation(.easeOut)
    .cancellable(id: CancelID.self)
  }
}

public struct JokeView: View {

  private let store: StoreOf<FeatureJoke>
  @ObservedObject private var viewStore: ViewStore<ViewState, FeatureJoke.Action>

  struct ViewState: Equatable {
    let loadingState: FeatureJoke.State.LoadingState
    let navigationTitle: String

    init(state: FeatureJoke.State) {
      self.loadingState = state.loadingState
      self.navigationTitle = state.category?.rawValue ?? "Random"
    }
  }

  public init(store: StoreOf<FeatureJoke>) {
    self.store = store
    self.viewStore = ViewStore(self.store.scope(state: ViewState.init))
  }

  public var body: some View {
    NavigationView {
      ZStack {
        contentView(viewStore: viewStore)
          .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              refreshButton(viewStore: viewStore)
            }
          }
          .navigationTitle(viewStore.navigationTitle)
      }
    }
  }

  @ViewBuilder
  private func refreshButton(viewStore: ViewStore<ViewState, FeatureJoke.Action>) -> some View {
    Button(action: { viewStore.send(.refreshTapped, animation: .easeOut) }) {
      Image(systemName: "arrow.2.circlepath")
    }
  }

  @ViewBuilder
  private func contentView(viewStore: ViewStore<ViewState, FeatureJoke.Action>) -> some View {
    switch viewStore.loadingState {
      case .failed:
        failedView
      case .loading:
        loadingView(viewStore: viewStore)
      case .loaded(let joke):
        jokeView(joke: joke)
    }
  }

  @ViewBuilder
  private func jokeView(joke: Joke) -> some View {
    ScrollView {
      VStack(spacing: 40) {
        Image("chucknorris", bundle: .module)
          .resizable()
          .scaledToFit()
          .padding(.top, 40)

        Text(joke.text)
          .font(.title)
        Spacer()
      }
      .padding(.horizontal, 20)
    }
  }

  @ViewBuilder
  private var failedView: some View {
    Text("Something went wrong")
  }

  @ViewBuilder
  private func loadingView(viewStore: ViewStore<ViewState, FeatureJoke.Action>) -> some View {
    if #available(iOS 15.0, *) {
      ProgressView()
        .task {
          await viewStore.send(.task).finish()
        }
    } else {
      ProgressView()
        .onAppear {
          viewStore.send(.onAppear)
        }
        .onDisappear {
          viewStore.send(.onDisappear)
        }
    }
  }
}
