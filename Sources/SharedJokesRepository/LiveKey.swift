//
//  Created by Nikita Borodulin on 12.10.2022.
//

import ComposableArchitecture
import Foundation
import LibraryAPIClient
import SharedModels

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
}
