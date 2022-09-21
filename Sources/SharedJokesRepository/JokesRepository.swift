//
//  Created by Nikita Borodulin on 02.09.2022.
//

import ComposableArchitecture
import Foundation
import LibraryAPIClient
import SharedModels
import XCTestDynamicOverlay

public struct JokesRepository: Sendable {
  public var categories: @Sendable () async throws -> [JokeCategory]
  public var randomJoke: @Sendable (JokeCategory?) async throws -> Joke
}

extension JokesRepository {

  public static func live(apiClient: APIClient) -> Self {
    .init(
      categories: {
        try await apiClient.send(API.jokes.categories.get).value.map(JokeCategory.init)
      },
      randomJoke: { category in
        Joke(text: try await apiClient.send(API.jokes.random(category: category).get).value.value)
      }
    )
  }

  struct Failure: Error {}
  public static let failing = Self(
    categories: {
      try await Task.sleep(nanoseconds: NSEC_PER_SEC)
      throw Failure()
    },
    randomJoke: { _ in
      try await Task.sleep(nanoseconds: NSEC_PER_SEC)
      throw Failure()
    }
  )
}

extension JokesRepository: TestDependencyKey {

  public static let previewValue = Self(
    categories: {
      [.init("Career"), .init("Family")]
    },
    randomJoke: { category in
      Joke(text: "Joke Preview")
    }
  )

  public static let testValue = Self(
    categories: XCTUnimplemented("\(Self.self).categories"),
    randomJoke: XCTUnimplemented("\(Self.self).randomJoke")
  )
}

public extension DependencyValues {
  var jokesRepository: JokesRepository {
    get { self[JokesRepository.self] }
    set { self[JokesRepository.self] = newValue }
  }
}
