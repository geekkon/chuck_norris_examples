//
//  StoreState.swift
//  ChuckNorris
//
//  Created by Sereja on 15.08.2022.
//

import ReSwift
import Combine
import Foundation

public class StoreState<T: Equatable>: ObservableObject, StoreSubscriber {

    @Published public var current: T
    private let store: Store<AppState>

    init(store: Store<AppState>, transform: @escaping (AppState) -> T) {
        self.current = transform(store.state)
        self.store = store

        store.subscribe(self) {
            $0.select(transform).skipRepeats()
        }
    }

    deinit {
        store.unsubscribe(self)
    }

    public func dispatch(_ action: Action) {
        store.dispatch(action)
    }

    public func newState(state: T) {
        DispatchQueue.main.async {
            self.current = state
        }
    }
}
