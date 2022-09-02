//
//  Created by Nikita Borodulin on 02.09.2022.
//

import ComposableArchitecture
import FeatureApp
import SwiftUI
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    true
  }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    let appView = AppView()
    window = (scene as? UIWindowScene).map { UIWindow(windowScene: $0) }
    window?.rootViewController = UIHostingController(rootView: appView)
    window?.makeKeyAndVisible()
  }
}
