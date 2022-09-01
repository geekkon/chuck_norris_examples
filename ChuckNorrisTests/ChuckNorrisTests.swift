//
//  ChuckNorrisTests.swift
//  ChuckNorrisTests
//
//  Created by Dim on 26.05.2021.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import ChuckNorris

class ChuckNorrisTests: XCTestCase {

    // MARK: ViewModel tests

    func test_categoriesViewModel_initialState_isLoading() {
        let httpService = HTTPServiceMock()
        let viewModel = CategoriesViewModel(httpService: httpService)

        XCTAssertTrue(viewModel.state.loading)
        XCTAssertTrue(viewModel.state.categories.isEmpty)

    }

    func test_categoriesViewModel_changesState_afterLoading() {
        let httpService = HTTPServiceMock()
        let viewModel = CategoriesViewModel(httpService: httpService)

        viewModel.handle(.ready)
        httpService.completion?(.success(["result"]))

        XCTAssertFalse(viewModel.state.loading)
        XCTAssertEqual(viewModel.state.categories.first, "result")
    }

    // MARK: Snapshot tests

    func test_jokeView() {
        
        let view = JokeView(
            viewModel: StaticViewModel(
                state: .init(title: "", loading: false, joke: "Chuck bez nunchack")
            )
        )

        assertSnapshot(matching: view.wrapped(), as: .image)
    }
}

private class HTTPServiceMock: HTTPService {

    var completion: ((Result<[APIResponse.Category], Error>) -> Void)?

    override func dispatch<R: HTTPRequest>(_ httpRequest: R, completion: @escaping (Result<R.Response, Error>) -> Void) {
        self.completion = completion as? (Result<[APIResponse.Category], Error>) -> Void
    }

//    override func getCategories(completion: @escaping (Result<[String], Error>) -> Void) {
//        self.completion = completion
//    }
}

extension SwiftUI.View {

    func wrapped() -> UIViewController {
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.frame = UIScreen.main.bounds
        return hostingController
    }
}
