import ComposableArchitecture
import SwiftUI

public struct Categories: ReducerProtocol {

  public struct State: Equatable {

    public init() {}
  }

  public enum Action: Equatable {
    case someAction
  }

  public init() {}

  public var body: some ReducerProtocol<State, Action> {
    EmptyReducer()
  }
}

public struct CategoriesView: View {

  let store: StoreOf<Categories>

  public init(store: StoreOf<Categories>) {
    self.store = store
  }

  public var body: some View {
    Color.blue
  }
}
