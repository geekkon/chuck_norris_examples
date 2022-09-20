//
//  JokeScene.swift
//  ChuckNorris
//
//  Created by Dim on 20.09.2022.
//

import UIKit
import SwiftUI

extension UIViewController {

    // Интересно как и куда пробрасывать входные параметры. Вот category например.
    // Сложил в Dependency, как бы не стало мусоркой 🫤
    static func jokeViewController(category: String? = nil) -> UIViewController {
        UIHostingController(
            rootView: JokeView(
                store: .init(
                    initial: .init(isLoading: true, title: "", joke: ""),
                    feedbacks: [.jokeTitle, .loadJoke],
                    reducer: .jokeReducer,
                    dependency: JokeDependency(category: category, httpService: .init())
                )
            )
        )
    }
}
