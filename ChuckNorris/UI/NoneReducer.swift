//
//  NoneReducer.swift
//  ChuckNorris
//
//  Created by Dim on 02.11.2022.
//

import Foundation
import ComposableArchitecture

struct NoneReducer<State, Action>: ReducerProtocol {

    func reduce(
        into state: inout State,
        action: Action
    ) -> EffectTask<Action> {
        .none
    }
}
