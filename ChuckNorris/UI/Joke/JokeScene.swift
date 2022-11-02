//
//  JokeScene.swift
//  ChuckNorris
//
//  Created by Dim on 02.11.2022.
//

import SwiftUI
import UIKit

extension UIViewController {

    static func jokeViewController(category: String? = nil) -> UIViewController {
        UIHostingController(
            rootView: JokeView(
                store: .init(
                    initialState: .init(
                        title: "",
                        loading: true,
                        joke: ""
                    ),
                    reducer: JokeReducer(category: category)
                )
            )
        )
    }
}
