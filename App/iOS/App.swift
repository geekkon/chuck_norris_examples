//
//  Created by Nikita Borodulin on 02.09.2022.
//

import FeatureApp
import Foundation
import SwiftUI
import UIKit

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

  var body: some Scene {
    WindowGroup {
      AppView()
    }
  }
}
