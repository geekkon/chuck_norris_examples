//
//  Created by Nikita Borodulin on 02.09.2022.
//

import ComposableArchitecture
import FeatureApp
import Foundation
import SwiftUI
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {

  fileprivate let store = Store(
    initialState: AppReducer.State(),
    reducer: AppReducer().transformDependency(\.self) {
        $0.jokesRepository = .live(apiClient: .live(baseURL: .init(string: "https://api.chucknorris.io")!))
      }
  )

  private lazy var viewStore = ViewStore(
    store.stateless
  )

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    viewStore.send(.appDelegate(.didFinishLaunching))
    return true
  }
}

@main
struct TCAChuckNorrisApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  var body: some Scene {
    WindowGroup {
      AppView(store: appDelegate.store)
    }
  }
}
