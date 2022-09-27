//
//  CategoriesViewController.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import UIKit
import SwiftUI
import ReSwift

final class CategoriesViewController: UIHostingController<CategoriesView> {

    private let store: Store<AppState>

    init(store: Store<AppState>) {
        self.store = store
        super.init(rootView: CategoriesView(store: store))

        store.subscribe(self) {
            $0.select({ $0.categoryState.selectedCategory != nil }).skipRepeats()
        }
    }

    deinit {
        store.unsubscribe(self)
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoriesViewController: StoreSubscriber {

    func newState(state: Bool) {
        if state {
            navigationController?.pushViewController(
                JokeViewController(store: store, sourceScreen: .category),
                animated: true
            )
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
