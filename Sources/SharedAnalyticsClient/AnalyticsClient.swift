//
//  Created by Nikita Borodulin on 02.09.2022.
//

import Foundation

public struct AnalyticsClient: Sendable {
  public var track: @Sendable (Event) async throws -> Void

  public init(track: @escaping @Sendable (Event) async throws -> Void) {
    self.track = track
  }
}

public struct Event {
  public init() {}
}
