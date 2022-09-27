//
//  JokeView.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import SwiftUI
import ReSwift

struct JokeView: View {
    
    @ObservedObject private var state: StoreState<JokeViewState>
    private let sourceScreen: JokeSourceScreen

    init(store: Store<AppState>, sourceScreen: JokeSourceScreen) {
        state = .init(store: store) { JokeViewState(appState: $0, sourceScreen: sourceScreen) }
        self.sourceScreen = sourceScreen
    }

    var body: some View {
        Group {
            if state.current.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(spacing: 40) {
                        Image("chucknorris")
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 40)
                        Text(state.current.text)
                            .font(.title)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationTitle(state.current.title)
        .navigationBarItems(
            trailing: Button(
                action: {
                    state.dispatch(JokeAction.load(sourceScreen))
                }
            ) {
                Image(systemName: "arrow.2.circlepath")
            }
        )
        .onAppear {
            state.dispatch(JokeAction.loadIfNeeded(sourceScreen))
        }
    }
}
