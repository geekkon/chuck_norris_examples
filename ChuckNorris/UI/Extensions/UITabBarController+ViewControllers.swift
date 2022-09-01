//
//  UITabBarController+ViewControllers.swift
//  ChuckNorris
//
//  Created by Dim on 27.05.2021.
//

import UIKit

extension UITabBarController {

    struct Tab {
        let name: String
        let icon: String
        let viewController: UIViewController
    }

    static func build(with tabs: [Tab]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = tabs.enumerated().map { index, tab in
            let navigationController = UINavigationController(rootViewController: tab.viewController)
            navigationController.tabBarItem = .init(
                title: tab.name,
                image: UIImage(systemName: tab.icon),
                tag: index
            )
            return navigationController
        }
        return tabBarController
    }
}
