//
//  Created by Nikita Borodulin on 02.09.2022.
//

import Foundation
import SharedModels

public struct JokesRepository: Sendable {
  public var categories: @Sendable () async throws -> [JokeCategory]
  public var randomJoke: @Sendable (JokeCategory?) async throws -> Joke
}
