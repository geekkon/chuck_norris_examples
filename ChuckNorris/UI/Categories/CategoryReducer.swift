//
//  CategoryReducer.swift
//  ChuckNorris
//
//  Created by Sereja on 12.08.2022.
//

import ReSwift

struct CategoryState: Equatable {
    var isLoading: Bool
    var categories: [String]
    var error: AppError?
    var selectedCategory: String?
}

func categoryReducer(state: CategoryState?, action: Action) -> CategoryState {
    var state = state ?? CategoryState(
        isLoading: false,
        categories: [],
        error: nil,
        selectedCategory: nil
    )

    switch action {
        case CategoryAction.setLoading where state.categories.isEmpty:
            state.isLoading = true
        case let CategoryAction.setCategories(categories):
            state.isLoading = false
            state.categories = categories
        case let CategoryAction.setError(error):
            state.isLoading = false
            state.error = error
        case let CategoryAction.selectCategory(category):
            state.selectedCategory = category
        case CategoryAction.removeCategory:
            state.selectedCategory = nil
        default:
            break
    }

    return state
}
