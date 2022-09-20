//
//  JokeViewModel.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import Foundation
import Combine

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

    private var cancellables: Set<AnyCancellable> = []

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

        httpService.publisher(for: request)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print(error)
                    }
                },
                receiveValue: { [weak self] joke in
                    self?.handle(joke: joke)
                }
            )
            .store(in: &cancellables)
    }

    func handle(joke: APIResponse.Joke) {
        state = .init(title: title, loading: false, joke: joke.value)
    }
}
