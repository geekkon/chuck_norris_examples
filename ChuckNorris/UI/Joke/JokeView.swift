//
//  JokeView.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import SwiftUI
import CombineFeedback

struct JokeView: View {

    let store: Store<JokeState, JokeEvent>

    var body: some View {
        WithContextView(store: store) { context in
            Content(isLoading: context.isLoading, joke: context.joke)
                .navigationTitle(context.title)
                .navigationBarItems(
                    trailing: Button {
                        context.send(event: .reload)
                    } label: {
                        Image(systemName: "arrow.2.circlepath")
                    }
                )
                .onAppear {
                    context.send(event: .reload)
                }
        }
    }
}

extension JokeView {

    struct Content: View {

        let isLoading: Bool
        let joke: String

        var body: some View {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(spacing: 40) {
                        Image("chucknorris")
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 40)

                        Text(joke)
                            .font(.title)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct JokeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            JokeView.Content(
                isLoading: false,
                joke: "A joke"
            )
            .navigationTitle("Preview")
        }
    }
}
