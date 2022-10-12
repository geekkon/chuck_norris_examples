//
//  Created by Nikita Borodulin on 12.10.2022.
//

import Dependencies
import Foundation
import XCTestDynamicOverlay

public extension DependencyValues {

  var analyticsClient: AnalyticsClient {
    get { self[AnalyticsClient.self] }
    set { self[AnalyticsClient.self] = newValue }
  }
}

extension AnalyticsClient: TestDependencyKey {

  public static let testValue = Self(
    track: XCTUnimplemented("\(Self.self).track")
  )
}
