//
//  Created by Nikita Borodulin on 06.09.2022.
//

import ComposableArchitecture
import FeatureJoke
import SharedModels
import SwiftUI

public struct CategoryRow: ReducerProtocol {

  public struct State: Equatable, Identifiable {
    let category: JokeCategory
    var selection: Identified<JokeCategory, FeatureJoke.State>?

    public var id: JokeCategory.ID {
      category.id
    }

    public init(category: JokeCategory, selection: Identified<JokeCategory, FeatureJoke.State>? = nil) {
      self.category = category
      self.selection = selection
    }
  }

  public enum Action: Equatable {
    case joke(FeatureJoke.Action)
    case setNavigation(selection: JokeCategory?)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
        case .joke:
          return .none
        case let .setNavigation(selection: .some(category)):
          state.selection = Identified(
            FeatureJoke.State(category: category),
            id: category
          )
          return .none
        case .setNavigation(selection: .none):
          state.selection = nil
          return .none
      }
    }
    .ifLet(\.selection, action: /Action.joke) {
      Scope(state: \Identified<JokeCategory, FeatureJoke.State>.value, action: /.self) {
        FeatureJoke()
      }
    }
  }
}

struct CategoryRowView: View {

  let store: StoreOf<CategoryRow>
  @ObservedObject private var viewStore: ViewStoreOf<CategoryRow>

  init(store: StoreOf<CategoryRow>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  var body: some View {
    NavigationLink(
      viewStore.category.rawValue,
      destination: IfLetStore(store.scope(state: \.selection?.value, action: CategoryRow.Action.joke)) {
        JokeView(store: $0)
      },
      tag: viewStore.category,
      selection: viewStore.binding(
        get: \.selection?.id,
        send: CategoryRow.Action.setNavigation(selection:)
      )
    )
  }
}
