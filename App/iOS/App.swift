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
  )

  fileprivate lazy var viewStore = ViewStore(
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

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    let appView = AppView(
      store: (UIApplication.shared.delegate as! AppDelegate).store
    )
    window = (scene as? UIWindowScene).map { UIWindow(windowScene: $0) }
    window?.rootViewController = UIHostingController(rootView: appView)
    window?.makeKeyAndVisible()
  }
}

@main
struct TCAChuckNorrisAppWrapper {

  static func main() {
    if #available(iOS 14.0, *) {
      TCAChuckNorrisApp.main()
    }
    else {
      UIApplicationMain(
        CommandLine.argc,
        CommandLine.unsafeArgv,
        nil,
        NSStringFromClass(AppDelegate.self)
      )
    }
  }
}

@available(iOS 14.0, *)
struct TCAChuckNorrisApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  var body: some Scene {
    WindowGroup {
      AppView(store: appDelegate.store)
    }
  }
}
