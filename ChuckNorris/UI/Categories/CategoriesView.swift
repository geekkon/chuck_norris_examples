//
//  CategoriesView.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import SwiftUI
import CombineFeedback

struct CategoriesView: View {

    let store: Store<CategoriesState, CategoriesEvent>

    var body: some View {
        WithContextView(store: store) { context in
            Content(
                isLoading: context.isLoading,
                categories: context.categories,
                onSelect: {
                    context.send(
                        event: .select(category: $0)
                    )
                }
            )
            .navigationTitle("Categories")
            .onAppear {
                context.send(event: .load)
            }
        }
    }
}

extension CategoriesView {

    struct Content: View {

        let isLoading: Bool
        let categories: [String]
        let onSelect: (String) -> Void

        var body: some View {
            if isLoading {
                ProgressView()
            } else {
                List(categories, id: \.self) { category in
                    Button(category) {
                        onSelect(category)
                    }
                }
            }
        }
    }
}

// Для того, чтобы завести превью решил разбить вью на две составляющие, вью-контейнер, которые дрерже стор и отвечает за связи с контекстом. И вью-контент, которую содержит и настраивает вью-контрейнер, и которую можно без дополнительных телодвижений подключить к превью
struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoriesView.Content(
                isLoading: false,
                categories: ["one", "two", "three"],
                onSelect: { _ in }
            )
            .navigationTitle("Preview")
        }
    }
}
