//
//  ChuckNorrisFcisTests.swift
//  ChuckNorrisTests
//
//  Created by Alexey Agapov on 21.09.2022.
//

import XCTest
import SwiftUI
@testable import ChuckNorris

class ChuckNorrisFcisTests: XCTestCase {

    func test_categoriesViewModel_actions() {
        perform(
            initial: .initial,
            action: .startLoading,
            expected: .init(loading: true, categories: []),
            expectedEffects: []
        )

        perform(
            initial: .init(loading: true, categories: []),
            action: .finishLoading(.success(["cat"])),
            expected: .init(loading: false, categories: ["cat"]),
            expectedEffects: []
        )

        perform(
            initial: .initial,
            action: .view(.ready),
            expected: .initial,
            expectedEffects: [.load]
        )

        perform(
            initial: .initial,
            action: .view(.select(category: "cat1")),
            expected: .initial,
            expectedEffects: [.route(category: "cat1")]
        )
    }

    private func perform(
        initial: CategoriesViewState,
        action: CategoriesAction,
        expected: CategoriesViewState,
        expectedEffects: [CategoriesViewModel.Effect]
    ) {
        var state = initial
        let effects = CategoriesViewModel.handleAction(
            action,
            state: &state
        )

        XCTAssertEqual(state, expected)
        XCTAssertEqual(effects, expectedEffects)
    }
}
