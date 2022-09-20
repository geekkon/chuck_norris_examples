//
//  JokeReducer.swift
//  ChuckNorris
//
//  Created by Dim on 20.09.2022.
//

import Foundation
import Combine
import CombineFeedback

struct JokeState: Equatable {
    var isLoading: Bool
    var title: String
    var joke: String
}

enum JokeEvent {
    case set(title: String)
    case reload
    case recieved(APIResponse.Joke)
    case failed
}

struct JokeDependency {
    var category: String?
    var httpService: HTTPService
}

extension Reducer where State == JokeState, Event == JokeEvent {

    static var jokeReducer = Reducer { state, event in
        switch event {
            case .set(let title):
                state.title = title
            case .reload:
                state.isLoading = true
            case .recieved(let joke):
                state.isLoading = false
                state.joke = joke.value
            case .failed:
                print("Failed")
        }
    }
}


extension Feedback {

    // Это херня конечно устанавливать title который выводится из category через Feedback и Dependency
    static var jokeTitle: Feedback<JokeState, JokeEvent, JokeDependency> {
        .middleware { state, dependency -> AnyPublisher<JokeEvent, Never> in
            guard state.title.isEmpty else {
                return Empty().eraseToAnyPublisher()
            }
            return Just(dependency.category?.capitalized ?? "Random")
                .map(JokeEvent.set)
                .eraseToAnyPublisher()
        }
    }

    static var loadJoke: Feedback<JokeState, JokeEvent, JokeDependency> {
        .middleware { state, dependency -> AnyPublisher<JokeEvent, Never> in

            guard state.isLoading else {
                return Empty().eraseToAnyPublisher()
            }

            let request = APIRequest.RandomJoke(category: dependency.category)
            return dependency.httpService.publisher(for: request)
                .map(JokeEvent.recieved)
                .catch { _ in
                    Just(JokeEvent.failed)
                }
                .eraseToAnyPublisher()
        }
    }
}
