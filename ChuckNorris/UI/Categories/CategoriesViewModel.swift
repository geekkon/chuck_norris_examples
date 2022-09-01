//
//  CategoriesViewModel.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import Foundation

struct CategoriesViewState {
    let loading: Bool
    let categories: [String]
}

enum CategoriesViewAction {
    case ready
    case select(category: String)
}

enum CategoriesViewRoute {
    case joke(category: String)
}

final class CategoriesViewModel: ViewModel {

    @Published var state: CategoriesViewState = .init(
        loading: true,
        categories: []
    )

    private let httpService: HTTPService

    var router: Router<CategoriesViewRoute>?

    init(httpService: HTTPService = .init()) {
        self.httpService = httpService
    }

    func handle(_ action: CategoriesViewAction) {
        switch action {
            case .ready:
                load()
            case .select(let category):
                router?(
                    .joke(category: category)
                )
        }
    }
}

private extension CategoriesViewModel {

    func load() {

        state = .init(loading: true, categories: [])

        let request = APIRequest.Categories()

        httpService.dispatch(request) { [weak self] result in
            switch result {
                case .success(let categories):
                    self?.handle(categories: categories)
                case .failure(let error):
                    print(error)
            }
        }
    }

    func handle(categories: [APIResponse.Category]) {
        state = .init(loading: false, categories: categories) // Mapping here if needed
    }
}
