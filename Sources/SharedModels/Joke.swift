//
//  Created by Nikita Borodulin on 02.09.2022.
//

import Foundation

public struct JokeResponseModel: Decodable {

  public let value: String

  public init(value: String) {
    self.value = value
  }
}

public struct Joke: Equatable, Sendable {

  public let text: String

  public init(text: String) {
    self.text = text
  }
}
