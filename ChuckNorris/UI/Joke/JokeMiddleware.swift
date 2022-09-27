//
//  JokeMiddleware.swift
//  ChuckNorris
//
//  Created by Sereja on 13.08.2022.
//

import ReSwift

enum JokeAction: Action, Equatable {
    case load(JokeSourceScreen)
    case loadIfNeeded(JokeSourceScreen)
    case setLoading(JokeSourceScreen)
    case setText(String, JokeSourceScreen)
    case setError(AppError)
}

enum JokeSourceScreen: String, Hashable {
    case category
    case random
}

struct JokeViewState: Equatable {
    let isLoading: Bool
    let text: String
    let title: String

    init(appState: AppState, sourceScreen: JokeSourceScreen) {
        guard let jokeState = appState.jokeState[sourceScreen] else {
            isLoading = false
            text = ""
            title = ""
            return
        }

        isLoading = jokeState.isLoading
        text = jokeState.text

        switch sourceScreen {
            case .category:
                title = appState.categoryState.selectedCategory ?? ""
            case .random:
                title = "Random"
        }
    }
}

func jokeMiddleware(httpService: HTTPService) -> Middleware<AppState> {
    { dispatch, getState in

        func loadJoke(sourceScreen: JokeSourceScreen) {
            var category: String?
            switch sourceScreen {
            case .category:
                category = getState()?.categoryState.selectedCategory
            case .random:
                break
            }

            let request = APIRequest.RandomJoke(category: category)
            dispatch(JokeAction.setLoading(sourceScreen))
            httpService.dispatch(request) { result in
                switch result {
                    case let .success(joke):
                        dispatch(JokeAction.setText(joke.value, sourceScreen))
                    case let .failure(error):
                        dispatch(JokeAction.setError(.undefined(error.localizedDescription)))
                }
            }
        }

        return { next in
            { action in

                switch action {
                    case let JokeAction.load(sourceScreen):
                        loadJoke(sourceScreen: sourceScreen)
                    case let JokeAction.loadIfNeeded(sourceScreen) where getState()?.jokeState[sourceScreen] == nil:
                        loadJoke(sourceScreen: sourceScreen)
                    default:
                        break
                }

                next(action)
            }
        }
    }
}
