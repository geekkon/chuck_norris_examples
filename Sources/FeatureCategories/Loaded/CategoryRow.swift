//
//  Created by Nikita Borodulin on 06.09.2022.
//

import ComposableArchitecture
import FeatureJoke
import SharedModels
import SwiftUI

public struct CategoryRow: Reducer {

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
    case setNavigation(selection: JokeCategory)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        case .joke(.onDisappear):
          state.selection = .none
          return .none
        case .joke:
          return .none
        case let .setNavigation(selection: category):
          state.selection = Identified(
            FeatureJoke.State(category: category),
            id: category
          )
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

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationLink(
        viewStore.category.rawValue,
        destination: IfLetStore(store.scope(state: \.selection?.value, action: CategoryRow.Action.joke)) {
          JokeView(store: $0)
        },
        tag: viewStore.category,
        selection: viewStore.binding(
          get: \.selection?.id,
          send: { selection in
            if let selection {
              return .setNavigation(selection: selection)
            } else {
              return .joke(.onDisappear)
            }
          }
        )
      )
    }
  }
}
