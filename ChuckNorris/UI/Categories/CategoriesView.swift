//
//  CategoriesView.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import ComposableArchitecture
import SwiftUI

struct CategoriesView: View {

    let store: Store<CategoriesReducer.State, CategoriesReducer.Action>

    var body: some View {

        WithViewStore(store) { viewStore in

            Group {

                if viewStore.loading {

                    ProgressView()

                } else {

                    List(viewStore.categories, id: \.self) { category in
                        Button(category) {
                            viewStore.send(
                                .select(category: category)
                            )
                        }
                    }

                }
            }
            .navigationTitle("Categories")
            .onAppear {
                viewStore.send(.load)
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoriesView(
                store: .init(
                    initialState: .init(
                        loading: false,
                        categories: ["one", "two", "three"]
                    ),
                    reducer: NoneReducer<CategoriesReducer.State, CategoriesReducer.Action>()
                )
            )
        }
    }
}
