//
//  CategoriesViewController.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import UIKit
import SwiftUI

final class CategoriesViewController: UIHostingController<CategoriesView<CategoriesViewModel>> {

    init() {
        let viewModel = CategoriesViewModel()
        super.init(
            rootView: CategoriesView(viewModel: viewModel)
        )
        viewModel.router = { [weak self] route in
            switch route {
                case .joke(let category):
                    self?.navigationController?.pushViewController(
                        JokeViewController(category: category),
                        animated: true
                    )
            }
        }
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
