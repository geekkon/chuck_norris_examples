//
//  Created by Nikita Borodulin on 12.10.2022.
//

import Dependencies
import Foundation
import SharedModels
import XCTestDynamicOverlay

extension DependencyValues {

  public var jokesRepository: JokesRepository {
    get { self[JokesRepository.self] }
    set { self[JokesRepository.self] = newValue }
  }
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

extension JokesRepository {

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
