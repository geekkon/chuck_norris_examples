//
//  JokeReducer.swift
//  ChuckNorris
//
//  Created by Dim on 02.11.2022.
//

import Foundation
import ComposableArchitecture

struct JokeReducer: ReducerProtocol {

    struct State: Equatable {
        var title: String
        var loading: Bool
        var joke: String
    }

    enum Action {
        case load
        case reload
        case recieved(joke: APIResponse.Joke)
        case failed
    }

    @Dependency(\.httpService) var httpService

    private let category: String?

    // ?? is it right to inject things in reducer?
    init(category: String?) {
        self.category = category
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            case .load:
                state.title = category?.capitalized ?? "Random"
                state.loading = true
                state.joke = ""
                return .loading(category: category, httpService: httpService)
            case .reload:
                state.loading = true
                state.joke = ""
                return .loading(category: category, httpService: httpService)
            case .recieved(let joke):
                state.loading = false
                state.joke = joke.value
                return .none
            case .failed:
                print("failed")
                state.loading = false
                state.joke = ""
                return .none
        }
    }
}

private extension Effect {

    static func loading(
        category: String?,
        httpService: HTTPService
    ) -> Effect<JokeReducer.Action, Never> {
        .init(
            httpService.publisher(
                for: APIRequest.RandomJoke(category: category)
            )
            .map(JokeReducer.Action.recieved)
            .replaceError(with: JokeReducer.Action.failed)
            .eraseToAnyPublisher()
        )
    }
}
