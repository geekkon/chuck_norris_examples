//
//  AppDelegate.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().prefersLargeTitles = true

        window?.rootViewController = UITabBarController.build(
            with: [
                .init(
                    name: "Categories",
                    icon: "list.dash",
                    viewController: .categoriesViewController()
                ),
                .init(
                    name: "Random",
                    icon: "star",
                    viewController: .jokeViewController()
                )
            ]
        )

        window?.makeKeyAndVisible()

        return true
    }
}
