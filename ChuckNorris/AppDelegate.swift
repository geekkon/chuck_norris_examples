//
//  AppDelegate.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import UIKit
import ReSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        UINavigationBar.appearance().prefersLargeTitles = true
        
        let httpService = HTTPService()
        let store = Store<AppState>(
            reducer: appReducer,
            state: nil,
            middleware: [
                categoryMiddleware(httpService: httpService),
                jokeMiddleware(httpService: httpService)
            ]
        )

        window?.rootViewController = UITabBarController.build(
            with: [
                .init(
                    name: "Categories",
                    icon: "list.dash",
                    viewController: CategoriesViewController(store: store)
                ),
                .init(
                    name: "Random",
                    icon: "star",
                    viewController: JokeViewController(store: store, sourceScreen: .random)
                )
            ]
        )

        window?.makeKeyAndVisible()

        return true
    }
}
