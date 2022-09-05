//
//  Created by Nikita Borodulin on 02.09.2022.
//

import ComposableArchitecture
import Foundation
import LibraryAPIClient
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

  private enum JokesRepositoryKey: TestDependencyKey {
    static let testValue = JokesRepository.unimplemented
  }
}

extension JokesRepository {

  public static func live(apiClient: APIClient) -> Self {
    .init(
      categories: { [] },
      randomJoke: { category -> Joke in
        Joke(text: try await apiClient.send(API.jokes.random(category: category).get).value.value)
      }
    )
  }
}

extension JokesRepository {
  public static let unimplemented = Self(
    categories: XCTUnimplemented("\(Self.self).categories"),
    randomJoke: XCTUnimplemented("\(Self.self).randomJoke")
  )
}
