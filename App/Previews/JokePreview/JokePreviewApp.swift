//
//  Created by Nikita Borodulin on 21.09.2022.
//

import ComposableArchitecture
import FeatureJoke
import SharedModels
import SwiftUI

@main
struct JokePreviewApp: App {

  var body: some Scene {
    WindowGroup {
      JokeView(
        store: .init(
          initialState: FeatureJoke.State(),
          reducer: FeatureJoke()
            .dependency(
              \.jokesRepository,
               .live(apiClient: .live(baseURL: .init(string: "https://api.chucknorris.io")!))
            )
        )
      )
    }
  }
}
