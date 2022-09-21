//
//  ChuckNorrisTests.swift
//  ChuckNorrisTests
//
//  Created by Dim on 26.05.2021.
//

import XCTest
import SnapshotTesting
import SwiftUI
import Combine
import CombineFeedback
@testable import ChuckNorris

class ChuckNorrisTests: XCTestCase {

    // MARK: CategoriesStore tests

    // Тест по аналогии с тестом, который был на viewModel. Выглядит бесполезным
    func test_categoriesStore_doesNotChangeInitialState_afterInit() {
        let httpService = HTTPServiceMock()
        let store: Store<CategoriesState, CategoriesEvent> = .init(
            initial: .init(isLoading: false, categories: []),
            feedbacks: [],
            reducer: .categoriesReducer,
            dependency: CategoriesDependency(
                httpService: httpService,
                router: .init()
            )
        )

        XCTAssertFalse(store.state.isLoading)
        XCTAssertTrue(store.state.categories.isEmpty)
    }

    func test_categoriesStore_changesState_afterLoadEvent() {
        let httpService = HTTPServiceMock()
        let store: Store<CategoriesState, CategoriesEvent> = .init(
            initial: .init(isLoading: false, categories: []),
            feedbacks: [],
            reducer: .categoriesReducer,
            dependency: CategoriesDependency(
                httpService: httpService,
                router: .init()
            )
        )

        store.send(event: .load)

        XCTAssertTrue(store.state.isLoading)
        XCTAssertTrue(store.state.categories.isEmpty)
    }

    func test_categoriesStore_changesState_afterRecievedEvent() {
        let httpService = HTTPServiceMock()
        let store: Store<CategoriesState, CategoriesEvent> = .init(
            initial: .init(isLoading: true, categories: []),
            feedbacks: [],
            reducer: .categoriesReducer,
            dependency: CategoriesDependency(
                httpService: httpService,
                router: .init()
            )
        )

        store.send(event: .recieved(categories: ["result"]))

        XCTAssertFalse(store.state.isLoading)
        XCTAssertEqual(store.state.categories, ["result"])
    }

    // TODO: аналогично можно протестировать роутинг через событие .select(category: String)
    // TODO: можно потестировать reducer изолированно, но как будто в этом мало смысла

    // MARK: Reducer.categoriesReducer tests

    func test_categoriesReducer_changesSate_basedOnEvent() {
        var state: CategoriesState = .init(isLoading: false, categories: [])

        Reducer.categoriesReducer(&state, .load)

        XCTAssertTrue(state.isLoading)
        XCTAssertTrue(state.categories.isEmpty)

        Reducer.categoriesReducer(&state, .recieved(categories: ["result"]))

        XCTAssertFalse(state.isLoading)
        XCTAssertEqual(state.categories, ["result"])
    }

    // MARK: Snapshot tests

    func test_snapshot_jokeView() {
        let httpService = HTTPServiceMock()
        let store: Store<JokeState, JokeEvent> = .init(
            initial: .init(isLoading: false, title: "", joke: "A joke"),
            feedbacks: [],
            reducer: .jokeReducer,
            dependency: JokeDependency(category: nil, httpService: httpService)
        )

        /* Вот тут есть проблема. Хотя я и устанавливаю state в Store initial
         на скриншоте статус загрузки. Происходит это потому что по onAppear вызывается
         событие загрузки, и чтобы я тут не менял в Store это не поможет, потому onAppear
         вызвается по факту снятия скриншота = всегда последнее событие.
         Решение ниже (использовать JokeView.Content напрямую) как в preview и тут заходит.
         Оставлю для наглядности
         */
        let view = JokeView(store: store)
        assertSnapshot(matching: view.wrapped(), as: .image)

        // Можно также тестировать JokeView.Content без создания Store
        let content = JokeView.Content(isLoading: false, joke: "Chuck bez nunchack")
        assertSnapshot(matching: content.wrapped(), as: .image)
    }
}

private class HTTPServiceMock: HTTPService {

    var categories: [APIResponse.Category] = []

    override func publisher<R: HTTPRequest>(for httpRequest: R) -> AnyPublisher<R.Response, Error> {
        Result.success(categories as! R.Response).publisher.eraseToAnyPublisher()
    }
}

extension SwiftUI.View {

    func wrapped() -> UIViewController {
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.frame = UIScreen.main.bounds
        return hostingController
    }
}
