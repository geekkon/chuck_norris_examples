//
//  Created by Nikita Borodulin on 02.09.2022.
//

import Foundation

public typealias JokeCategoryResponseModel = String

public struct JokeCategory: Equatable {

  public let rawValue: String

  public init(_ rawValue: String) {
    self.rawValue = rawValue
  }
}
