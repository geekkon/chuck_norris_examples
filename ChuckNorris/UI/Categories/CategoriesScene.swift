//
//  CategoriesScene.swift
//  ChuckNorris
//
//  Created by Dim on 20.09.2022.
//

import UIKit
import SwiftUI

// Решил не выносить сборку в отдельную сущность. На вызывающе стороне выглядит органично и по смыслу подходит exetnsion на UIViewController
extension UIViewController {

    static func categoriesViewController() -> UIViewController {
        let router = CategoriesRouter()
        let controller = UIHostingController(
            rootView: CategoriesView(
                // Возможно есть смысл вынести создание стора в extension рядом с reducer
                store: .init(
                    initial: .init(
                        isLoading: true,
                        categories: []
                    ),
                    feedbacks: [.loading, .routing],
                    reducer: .categoriesReducer,
                    dependency: CategoriesDependency(httpService: .init(), router: router)
                )
            )
        )
        router.controller = controller
        return controller
    }
}

final class CategoriesRouter {

    enum Route {
        case joke(category: String)
    }

    // Можно сделать fileprivate раз сборка тут же ниже
    fileprivate weak var controller: UIViewController?

    func handle(_ route: Route) {
        switch route {
            case .joke(let category):
                controller?.navigationController?.pushViewController(
                    .jokeViewController(category: category),
                    animated: true
                )
        }
    }
}
