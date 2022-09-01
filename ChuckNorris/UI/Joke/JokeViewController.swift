//
//  JokeViewController.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import UIKit
import SwiftUI

final class JokeViewController: UIHostingController<JokeView<JokeViewModel>> {

    init(category: String? = nil) {
        let viewModel = JokeViewModel(category: category)
        super.init(
            rootView: JokeView(viewModel: viewModel)
        )
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
