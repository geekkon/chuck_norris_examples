//
//  ViewModel.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import Foundation

protocol ViewModel: ObservableObject {

    associatedtype State
    associatedtype Action

    var state: State { get }

    func handle(_ action: Action)
}

class StaticViewModel<State, Action>: ViewModel {

    let state: State

    init(state: State) {
        self.state = state
    }

    func handle(_ action: Action) {}
}
