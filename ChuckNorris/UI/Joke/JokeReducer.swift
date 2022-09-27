//
//  JokeReducer.swift
//  ChuckNorris
//
//  Created by Sereja on 13.08.2022.
//

import ReSwift

struct JokeState: Equatable {
    var isLoading: Bool
    var text: String
}

func jokeReducer(state: [JokeSourceScreen: JokeState]?, action: Action) -> [JokeSourceScreen: JokeState] {
    var state = state ?? [:]

    switch action {
        case let JokeAction.setLoading(sourceScreen):
            state[sourceScreen] = JokeState(isLoading: true, text: "")
        case let JokeAction.setText(text, sourceScreen):
            state[sourceScreen] = JokeState(isLoading: false, text: text)
        case CategoryAction.removeCategory:
            state.removeValue(forKey: .category)
        default:
            break
    }

    return state
}
