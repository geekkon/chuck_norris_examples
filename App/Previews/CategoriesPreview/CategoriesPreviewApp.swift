//
//  Created by Nikita Borodulin on 21.09.2022.
//

import ComposableArchitecture
import FeatureCategories
import SharedModels
import SwiftUI

@main
struct JokePreviewApp: App {

  var body: some Scene {
    WindowGroup {
      NavigationView {
        CategoriesView(
          store: .init(
            initialState: FeatureCategories.State(),
            reducer: FeatureCategories()
              .dependency(
                \.jokesRepository,
                 .live(apiClient: .live(baseURL: .init(string: "https://api.chucknorris.io")!))
              )
          )
        )
      }
    }
  }
}
