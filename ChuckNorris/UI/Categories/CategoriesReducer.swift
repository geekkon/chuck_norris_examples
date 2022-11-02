//
//  CategoriesReducer.swift
//  ChuckNorris
//
//  Created by Dim on 05.10.2022.
//

import ComposableArchitecture
import Foundation

struct CategoriesReducer: ReducerProtocol {

    struct State: Equatable {
        var loading: Bool
        var categories: [String]
    }

    enum Action {
        case load
        case select(category: String)
        case recieved(categories: [APIResponse.Category])
        case failed
    }

    @Dependency(\.httpService) var httpService
    // TOOD: try to inject?
//    @Dependency(\.categoriesRouter) var router

    private let router: CategoriesRouter // TODO: replace with @Dependency??

    // TODO: remove with @Dependency??
    init(router: CategoriesRouter) {
        self.router = router
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            case .load:
                state.loading = true
                state.categories = []
                return .loading(httpService: httpService)
            case .select(let category):
                router.handle(
                    route: .joke(category: category)
                )
                return .none
            case .recieved(let categories):
                state.loading = false
                state.categories = categories
                return .none
            case .failed:
                print("failed")
                state.loading = false
                state.categories = []
                return .none
        }
    }
}

private extension Effect {

    static func loading(
        httpService: HTTPService
    ) -> Effect<CategoriesReducer.Action, Never> {
        .init(
            httpService.publisher(
                for: APIRequest.Categories()
            )
            .map(CategoriesReducer.Action.recieved)
            .replaceError(with: CategoriesReducer.Action.failed)
            .eraseToAnyPublisher()
        )
    }
}
