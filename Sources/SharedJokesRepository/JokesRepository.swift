//
//  Created by Nikita Borodulin on 02.09.2022.
//

import ComposableArchitecture
import Foundation
import SharedModels
import XCTestDynamicOverlay

public struct JokesRepository {
  public var categories: @Sendable () async throws -> [JokeCategory]
  public var randomJoke: @Sendable (JokeCategory?) async throws -> Joke
}

extension DependencyValues {

  public var jokesRepository: JokesRepository {
    get { self[JokesRepositoryKey.self] }
    set { self[JokesRepositoryKey.self] = newValue }
  }

  private enum JokesRepositoryKey: DependencyKey {
    static let liveValue = JokesRepository.live
    static let testValue = JokesRepository.unimplemented
  }
}

extension JokesRepository {
  static let live = Self(
    categories: { [] },
    randomJoke: { _ in
      try! await Task.sleep(nanoseconds: NSEC_PER_SEC)
      return Joke(text: "JOKE")
    }
  )
}

extension JokesRepository {
  public static let unimplemented = Self(
    categories: XCTUnimplemented("\(Self.self).categories"),
    randomJoke: XCTUnimplemented("\(Self.self).randomJoke")
  )
}
