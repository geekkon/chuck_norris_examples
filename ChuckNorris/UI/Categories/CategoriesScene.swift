//
//  CategoriesScene.swift
//  ChuckNorris
//
//  Created by Dim on 05.10.2022.
//

import ComposableArchitecture
import SwiftUI
import UIKit

extension UIViewController {

    static func categoriesViewController() -> UIViewController {
        let router: CategoriesRouter = .init()
        let controller = UIHostingController(
            rootView: CategoriesView(
                store: .init(
                    initialState: .init(
                        loading: true,
                        categories: []
                    ),
                    reducer: CategoriesReducer()
                        .dependency(\.categoriesRouter, router)
                )
            )
        )
        router.controller = controller
        return controller
    }
}

typealias Router<T> = (T) -> Void

final class CategoriesRouter {

    enum Route {
        case joke(category: String)
    }

    weak var controller: UIViewController?

    func handle(route: Route) {
        switch route {
            case .joke(let category):
                print("selection \(category)")
                controller?.navigationController?.pushViewController(
                    .jokeViewController(category: category),
                    animated: true
                )
        }
    }
}

// TODO: fix when find out how to deal with @Dependency
private enum CategoriesRouterKey: DependencyKey {
    static let liveValue: CategoriesRouter = .init()
}

extension DependencyValues {

    var categoriesRouter: CategoriesRouter {
        get { self[CategoriesRouterKey.self] }
        set { self[CategoriesRouterKey.self] = newValue }
    }
}
