//
//  JokeViewModel.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import Foundation

struct JokeViewState {
    let title: String
    let loading: Bool
    let joke: String
}

enum JokeViewAction {
    case reload
}

final class JokeViewModel: ViewModel {

    @Published var state: JokeViewState = .init(
        title: "",
        loading: true,
        joke: ""
    )

    private let httpService: HTTPService
    private let category: String?

    private var title: String {
        category?.capitalized ?? "Random"
    }

    init(httpService: HTTPService = .init(), category: String? = nil) {
        self.httpService = httpService
        self.category = category
        load()
    }

    func handle(_ action: JokeViewAction) {
        switch action {
            case .reload:
                load()
        }
    }
}

private extension JokeViewModel {

    func load() {

        state = .init(title: title, loading: true, joke: "")

        let request = APIRequest.RandomJoke(category: category)

        httpService.dispatch(request) { [weak self] result in
            switch result {
                case .success(let joke):
                    self?.handle(joke: joke)
                case .failure(let error):
                    print(error)
            }
        }
    }

    func handle(joke: APIResponse.Joke) {
        state = .init(title: title, loading: false, joke: joke.value)
    }
}
