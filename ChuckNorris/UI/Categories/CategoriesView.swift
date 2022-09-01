//
//  CategoriesView.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import SwiftUI

struct CategoriesView<T: ViewModel>: View where T.State == CategoriesViewState, T.Action == CategoriesViewAction {

    @ObservedObject var viewModel: T

    init(viewModel: T) {
        self.viewModel = viewModel
        print("CategoriesView init")
    }

    var body: some View {

        Group {

            if viewModel.state.loading {

                ProgressView()

            } else {

                List(viewModel.state.categories, id: \.self) { category in
                    Button(category) {
                        viewModel.handle(
                            .select(category: category)
                        )
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .onAppear {
            viewModel.handle(.ready)
            print("CategoriesView onAppear")
        }
    }
}


struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoriesView(
                viewModel: StaticViewModel(
                    state: .init(
                        loading: false,
                        categories: ["one", "two", "three"]
                    )
                )
            )
        }
    }
}
