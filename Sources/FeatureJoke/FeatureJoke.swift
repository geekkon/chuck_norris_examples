import ComposableArchitecture
import SharedJokesRepository
import SharedModels
import SwiftUI

public struct FeatureJoke: ReducerProtocol {

  public struct State: Equatable {

    public enum LoadingState: Equatable {
      case failed
      case initial
      case loading
      case loaded(Joke)
    }

    public let category: JokeCategory?
    public var loadingState: LoadingState

    public init(
      category: JokeCategory? = nil,
      loadingState: LoadingState = .initial
    ) {
      self.category = category
      self.loadingState = loadingState
    }
  }

  public enum Action: Equatable {
    case jokeLoaded(TaskResult<Joke>)
    case onAppear
    case onDisappear
    case refreshTapped
    case timerTicked
  }

  private enum JokeLoadingID {}
  private enum TimerID {}

  @Dependency(\.jokesRepository) var jokesRepository
  @Dependency(\.mainQueue) var mainQueue

  public init() {}

  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
      case .jokeLoaded(.failure):
        state.loadingState = .failed
        return .none
      case let .jokeLoaded(.success(joke)):
        state.loadingState = .loaded(joke)
        return startTimer()
      case .onAppear:
        switch state.loadingState {
          case .initial:
            return loadJoke(state: &state)
          case .loaded:
            return startTimer()
          case .failed, .loading:
            return .none
        }
      case .onDisappear:
        switch state.loadingState {
          case .loading:
            state.loadingState = .initial
            return .cancel(id: JokeLoadingID.self)
          case .loaded:
            return .cancel(id: TimerID.self)
          case .failed, .initial:
            return .none
        }
      case .refreshTapped:
        guard state.loadingState != .loading else {
          return .none
        }
        return .concatenate(
          .cancel(id: TimerID.self),
          loadJoke(state: &state)
        )
      case .timerTicked:
        return .concatenate(
          .cancel(id: TimerID.self),
          loadJoke(state: &state)
        )
    }
  }

  private func loadJoke(state: inout State) -> Effect<Action, Never> {
    state.loadingState = .loading
    return .task { [category = state.category, repository = jokesRepository] in
      await .jokeLoaded(TaskResult { try await repository.randomJoke(category) })
    }
    .animation(.easeOut)
    .cancellable(id: JokeLoadingID.self)
  }

  private func startTimer() -> Effect<Action, Never> {
    .run { send in
      for await _ in self.mainQueue.timer(interval: .seconds(3)) {
        await send(.timerTicked, animation: .easeOut)
      }
    }
    .cancellable(id: TimerID.self)
  }
}

public struct JokeView: View {

  private let store: StoreOf<FeatureJoke>

  struct ViewState: Equatable {
    let loadingState: FeatureJoke.State.LoadingState
    let navigationTitle: String
    let shouldSendOnDisappear: Bool

    init(state: FeatureJoke.State) {
      self.loadingState = state.loadingState
      self.navigationTitle = state.category?.rawValue ?? "Random"
      self.shouldSendOnDisappear = state.category == nil
    }
  }

  public init(store: StoreOf<FeatureJoke>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      ZStack {
        contentView(viewStore: viewStore)
          .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              refreshButton(viewStore: viewStore)
            }
          }
          .navigationTitle(viewStore.navigationTitle)
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
      .onDisappear {
        if viewStore.shouldSendOnDisappear {
          viewStore.send(.onDisappear)
        }
      }
    }
  }

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
      case .initial, .loading:
        ProgressView()
      case .loaded(let joke):
        jokeView(joke: joke)
    }
  }

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

  private var failedView: some View {
    Text("Something went wrong")
  }
}

struct JokeView_Previews: PreviewProvider {

  static var previews: some View {
    NavigationView {
      JokeView(
        store: .init(
          initialState: FeatureJoke.State(),
          reducer: FeatureJoke()
        )
      )
    }
  }
}
