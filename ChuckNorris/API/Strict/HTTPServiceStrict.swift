//
//  HTTPServiceStrict.swift
//  ChuckNorris
//
//  Created by Dim on 26.05.2021.
//

import Foundation


class HTTPServiceStrict {

    func getCategories(completion: @escaping (Result<[String], Error>) -> Void) {

        let url = URL(string: "https://api.chucknorris.io/jokes/categories")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            data.map { data in
                DispatchQueue.main.async {
                    do {
                        completion(
                            .success(
                                try JSONDecoder().decode([String].self, from: data)
                            )
                        )
                    } catch {
                        completion(
                            .failure(error)
                        )
                    }
                }
            }
        }
        .resume()
    }

    func getJoke(category: String? = nil, completion: @escaping (Result<JokeStrict, Error>) -> Void) {

        let category = category.map { "?category=\($0)" } ?? ""

        let url = URL(string: "https://api.chucknorris.io/jokes/random\(category)")!


        URLSession.shared.dataTask(with: url) { data, response, error in
            data.map { data in
                DispatchQueue.main.async {
                    do {
                        completion(
                            .success(
                                try JSONDecoder().decode(JokeStrict.self, from: data)
                            )
                        )
                    } catch {
                        completion(
                            .failure(error)
                        )
                    }
                }
            }
        }
        .resume()
    }
}
