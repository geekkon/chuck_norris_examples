//
//  JokeView.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import SwiftUI

typealias State = JokeViewState
typealias Action = JokeViewAction

struct JokeView<T: ViewModel>: View where T.State == State, T.Action == Action {

    @ObservedObject var viewModel: T

    init(viewModel: T) {
        self.viewModel = viewModel
        print("JokeView init")
    }

    var body: some View {

        Group {

            if viewModel.state.loading {

                ProgressView()

            } else {

                ScrollView {
                    
                    VStack(spacing: 40) {
                        Image("chucknorris")
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 40)

                        Text(viewModel.state.joke)
                            .font(.title)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationTitle(viewModel.state.title)
        .navigationBarItems(
            trailing: Button(
                action: {
                    viewModel.handle(.reload)
                }
            ) {
                Image(systemName: "arrow.2.circlepath")
            }
        )
        .onAppear {
            print("JokeView onAppear")
        }
    }
}

struct JokeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            JokeView(
                viewModel: StaticViewModel(
                    state: .init(
                        title: "Preview",
                        loading: false,
                        joke: "A joke"
                    )
                )
            )
        }
    }
}
