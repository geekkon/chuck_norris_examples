//
//  CategoriesView.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import SwiftUI
import ReSwift

struct CategoriesView: View {

    @ObservedObject var state: StoreState<CategoryState>

    init(store: Store<AppState>) {
        state = .init(store: store, transform: \.categoryState)
    }

    var body: some View {
        Group {
            if state.current.isLoading {
                ProgressView()
            } else {
                List(state.current.categories, id: \.self) { category in
                    Button(category) {
                        state.dispatch(CategoryAction.selectCategory(category))
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .onAppear {
            state.dispatch(CategoryAction.load)
        }
    }
}
