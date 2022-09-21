//
//  CategoriesViewModel.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import Foundation

struct CategoriesViewState: Equatable {
    var loading: Bool
    var categories: [String]

    static var initial: Self {
        .init(loading: false, categories: [])
    }
}

enum CategoriesAction {
    enum View {
        case ready
        case select(category: String)
    }
    case view(View)
    case startLoading
    case finishLoading(Result<APIRequest.Categories.Response, Error>)
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

    func handle(_ action: CategoriesAction.View) {
        handleAction(.view(action))
    }

    private func handleAction(_ action: CategoriesAction) {
        let effects = Self.handleAction(action, state: &state)
        effects.forEach {
            switch $0 {
                case .load:
                    load()
                case .route(let category):
                    router?(.joke(category: category))
            }
        }
    }
}

private extension CategoriesViewModel {

    func load() {
        handleAction(.startLoading)
        let request = APIRequest.Categories()
        httpService.dispatch(request) { [weak self] result in
            self?.handleAction(.finishLoading(result))
        }
    }
}

extension CategoriesViewModel {

    enum Effect: Equatable {
        case load
        case route(category: String)
    }
    static func handleAction(_ action: CategoriesAction, state: inout State) -> [Effect] {
        switch action {
            case .startLoading:
                state.loading = true
                return []
            case .finishLoading(let result):
                switch result {
                    case .success(let categories):
                        state.loading = false
                        state.categories = categories // Mapping here if needed
                    case .failure(let error):
                        print(error)
                }
                return []
            case .view(.ready):
                return [.load]
            case .view(.select(let category)):
                return [.route(category: category)]
        }
    }
}
