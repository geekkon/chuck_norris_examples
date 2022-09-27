//
//  ChuckNorrisTests.swift
//  ChuckNorrisTests
//
//  Created by Dim on 26.05.2021.
//

import XCTest
import SwiftUI
import ReSwift

@testable import ChuckNorris

class JokeMiddlewareTests: XCTestCase {
    
    private var httpService: HTTPServiceMock!
    private var environment: EnvironmentMock!
    private var middleware: Middleware<AppState>!

    override func setUp() {
        httpService = .init()
        environment = .init()
        middleware = jokeMiddleware(httpService: httpService)
    }

    func test_load_random_success() {
        // given
        httpService.mockResponse = Result<APIRequest.RandomJoke.Response, Error>.success(Consts.successResponse)
        let first = middleware(environment.dispatch, environment.getState(nil))
        let last = first(environment.next)
        
        // when
        last(JokeAction.load(Consts.sourceScreenRandom))
        
        // then
        XCTAssertEqual(httpService.dispatchWasCalled, 1)
        XCTAssertEqual((httpService.httpRequest as? APIRequest.RandomJoke)?.path, "/random")
        XCTAssertEqual(environment.dispatchCalled, 2)
        XCTAssertEqual(
            environment.dispatchedActions.first as? JokeAction,
            JokeAction.setLoading(Consts.sourceScreenRandom)
        )
        XCTAssertEqual(
            environment.dispatchedActions.last as? JokeAction,
            JokeAction.setText(Consts.successResponse.value, Consts.sourceScreenRandom)
        )
    }

    func test_load_category_error() {
        // given
        httpService.mockResponse = Result<APIRequest.RandomJoke.Response, Error>.failure(Consts.errorResponse)
        let first = middleware(environment.dispatch, environment.getState(Consts.appStateCategory))
        let last = first(environment.next)
        
        // when
        last(JokeAction.load(Consts.sourceScreenCategory))
        
        // then
        XCTAssertEqual(httpService.dispatchWasCalled, 1)
        XCTAssertEqual((httpService.httpRequest as? APIRequest.RandomJoke)?.path, "/random?category=Home")
        XCTAssertEqual(environment.dispatchCalled, 2)
        XCTAssertEqual(
            environment.dispatchedActions.first as? JokeAction,
            JokeAction.setLoading(Consts.sourceScreenCategory)
        )
        XCTAssertEqual(
            environment.dispatchedActions.last as? JokeAction,
            JokeAction.setError(AppError.undefined(Consts.errorResponse.localizedDescription))
        )
    }

    enum Consts {
        static let sourceScreenRandom = JokeSourceScreen.random
        static let sourceScreenCategory = JokeSourceScreen.category
        static let appStateCategory = AppState(
            categoryState: CategoryState(isLoading: false, categories: [], error: nil, selectedCategory: "Home"),
            jokeState: [:]
        )
        static let successResponse = APIRequest.RandomJoke.Response(
            icon_url: "icon_url",
            id: "id",
            url: "url",
            value: "value"
        )
        static let errorResponse = NSError(domain: "Internal error", code: 504)
    }
}

private class HTTPServiceMock: HTTPService {
    // set
    var mockResponse: Any?
    // check
    var httpRequest: Any?
    var dispatchWasCalled: Int = 0

    override func dispatch<R: HTTPRequest>(_ httpRequest: R, completion: @escaping (Result<R.Response, Error>) -> Void) {
        dispatchWasCalled += 1
        self.httpRequest = httpRequest

        if let response = mockResponse as? Result<R.Response, Error> {
            completion(response)
        }
    }
}

private class EnvironmentMock {

    var dispatchCalled = 0
    var dispatchedActions: [Action] = []

    private(set) lazy var dispatch: DispatchFunction = { [self] action in
        dispatchCalled += 1
        dispatchedActions.append(action)
    }

    var getStateCalled = 0

    private(set) lazy var getState: (AppState?) -> () -> AppState? = { [self] appState in
        {
            self.getStateCalled += 1
            return appState
        }
    }

    var nextCalled = 0
    var nextAction: Action?

    private(set) lazy var next: DispatchFunction = { [self] action in
        nextCalled += 1
        nextAction = action
    }
}

extension SwiftUI.View {

    func wrapped() -> UIViewController {
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.frame = UIScreen.main.bounds
        return hostingController
    }
}
