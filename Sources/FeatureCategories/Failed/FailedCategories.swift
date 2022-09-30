//
//  Created by Nikita Borodulin on 06.09.2022.
//

import ComposableArchitecture
import SwiftUI

public struct FailedCategories: ReducerProtocol {

  public struct State: Equatable {
    public init() {}
  }

  public enum Action: Equatable {
    case retry
  }

  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    .none
  }
}

struct FailedCategoriesView: View {

  let store: StoreOf<FailedCategories>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        Text("Something went wrong")
        Button("Retry", action: { viewStore.send(.retry) })
      }
    }
  }
}