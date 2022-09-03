//
//  Created by Nikita Borodulin on 02.09.2022.
//

import ComposableArchitecture
import FeatureUserSettings
import Foundation

public struct AppDelegateReducer: ReducerProtocol {

  public typealias State = UserSettings

  public enum Action: Equatable {
    case didFinishLaunching
  }

  public init() {}

  public var body: some ReducerProtocol<State, Action> {
    EmptyReducer()
  }
}
