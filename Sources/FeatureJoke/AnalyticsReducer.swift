//
//  Created by Nikita Borodulin on 03.10.2022.
//

import ComposableArchitecture
import SharedAnalytics
import SharedModels

extension ReducerProtocol where Action == FeatureJoke.Action, State == FeatureJoke.State {

  func analytics() -> some ReducerProtocol<State, Action> {
    Analytics(base: self)
  }
}

private struct Analytics<Base: ReducerProtocol<FeatureJoke.State, FeatureJoke.Action>>: ReducerProtocol {

  @Dependency(\.analyticsClient) var analyticsClient

  let base: Base

  var body: some ReducerProtocol<FeatureJoke.State, FeatureJoke.Action> {
    self.base
    Reduce { state, action in
      switch action {
        case .jokeLoaded(.success):
          return .fireAndForget { [analyticsClient = self.analyticsClient] in
            try await analyticsClient.track(Event())
          }
        default:
          return .none
      }
    }
  }
}
