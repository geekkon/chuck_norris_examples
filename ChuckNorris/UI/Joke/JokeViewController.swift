//
//  JokeViewController.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import UIKit
import SwiftUI
import ReSwift

final class JokeViewController: UIHostingController<JokeView> {

    private let store: Store<AppState>

    init(store: Store<AppState>, sourceScreen: JokeSourceScreen) {
        self.store = store
        super.init(rootView: JokeView(store: store, sourceScreen: sourceScreen))
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        store.dispatch(CategoryAction.removeCategory)
    }
}
