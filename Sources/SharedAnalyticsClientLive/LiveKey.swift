//
//  Created by Nikita Borodulin on 12.10.2022.
//

import Dependencies
import Foundation
import SharedAnalyticsClient
import XCTestDynamicOverlay

/*
 The line below taxes the compiler and simulates building some complex dependency like one depending on Firebase.
 As this live implementation of the AnalyticsClient is separated from the client's interface, uncommenting this line doesn't affect
 build time of the features depending on the AnalyticsClient, since they depend on the interface module only
 */

//let x = String(
//  1 - 1 + 1.0 - 1 == 1 - 1 + 1.0 - 1 + 1.0
//    ? 1 + 1 + 1.0
//    : 1.0 - 1.0
//)

extension AnalyticsClient: DependencyKey {
  
  public static let liveValue = Self(
    track: { _ in
      try await Task.sleep(nanoseconds: NSEC_PER_SEC)
    }
  )
}
