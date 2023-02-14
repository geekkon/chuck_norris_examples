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
    reducer: AppReducer()
  ) {
    $0.jokesRepository = .live(apiClient: .live(baseURL: .init(string: "https://api.chucknorris.io")!))
  }

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    ViewStore(store, observe: { $0 }).send(.appDelegate(.didFinishLaunching))
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
