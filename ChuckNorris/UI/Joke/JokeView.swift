//
//  JokeView.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import ComposableArchitecture
import SwiftUI

struct JokeView: View {

    let store: Store<JokeReducer.State, JokeReducer.Action>

    var body: some View {

        WithViewStore(store) { viewStore in

            Group {

                if viewStore.loading {

                    ProgressView()

                } else {

                    ScrollView {

                        VStack(spacing: 40) {
                            Image("chucknorris")
                                .resizable()
                                .scaledToFit()
                                .padding(.top, 40)

                            Text(viewStore.joke)
                                .font(.title)

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationTitle(viewStore.title)
            .navigationBarItems(
                trailing: Button(
                    action: {
                        viewStore.send(.reload)
                    }
                ) {
                    Image(systemName: "arrow.2.circlepath")
                }
            )
            .onAppear {
                viewStore.send(.load)
            }
        }
    }
}

struct JokeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            JokeView(
                store: .init(
                    initialState: .init(
                        title: "Preview",
                        loading: false,
                        joke: "A joke"
                    ),
                    reducer: NoneReducer<JokeReducer.State, JokeReducer.Action>()
                )
            )
        }
    }
}
