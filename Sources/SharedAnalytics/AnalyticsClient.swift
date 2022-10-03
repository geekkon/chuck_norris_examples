//
//  Created by Nikita Borodulin on 02.09.2022.
//

import Dependencies
import Foundation
import XCTestDynamicOverlay

public struct Event {

  public init() {}
}

public struct AnalyticsClient: Sendable {

  public var track: @Sendable (Event) async throws -> Void
}

extension AnalyticsClient: DependencyKey {

  public static let liveValue = Self(
    track: { _ in
      try await Task.sleep(nanoseconds: NSEC_PER_SEC)
    }
  )

  public static let testValue = Self(
    track: XCTUnimplemented("\(Self.self).track")
  )
}

public extension DependencyValues {

  var analyticsClient: AnalyticsClient {
    get { self[AnalyticsClient.self] }
    set { self[AnalyticsClient.self] = newValue }
  }

}
