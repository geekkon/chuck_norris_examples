//
//  Created by Nikita Borodulin on 06.09.2022.
//

import ComposableArchitecture
import SharedModels
import SwiftUI

public struct LoadedCategories: ReducerProtocol {

  public struct State: Equatable {

    public var categories: IdentifiedArrayOf<CategoryRow.State>

    public init(categories: IdentifiedArrayOf<CategoryRow.State> = []) {
      self.categories = categories
    }
  }

  public enum Action: Equatable {
    case category(id: JokeCategory.ID, action: CategoryRow.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    EmptyReducer()
      .forEach(\.categories, action: /Action.category) {
        CategoryRow()
      }
  }
}

struct LoadedCategoriesView: View {

  let store: StoreOf<LoadedCategories>

  var body: some View {
    List {
      ForEachStore(store.scope(state: \.categories, action: LoadedCategories.Action.category)) { category in
        CategoryRowView(store: category)
      }
    }
  }
}
