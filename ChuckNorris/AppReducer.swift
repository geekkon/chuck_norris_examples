//
//  AppReducer.swift
//  ChuckNorris
//
//  Created by Sereja on 13.08.2022.
//

import ReSwift

struct AppState {
    let categoryState: CategoryState
    let jokeState: [JokeSourceScreen: JokeState]
}

enum AppError: Error, Equatable {
    case undefined(String)
}

func appReducer(action: Action, state: AppState?) -> AppState {
    AppState(
        categoryState: categoryReducer(state: state?.categoryState, action: action),
        jokeState: jokeReducer(state: state?.jokeState, action: action)
    )
}
