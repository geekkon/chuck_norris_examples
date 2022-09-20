//
//  APIRequest.swift
//  ChuckNorris
//
//  Created by Dim on 15.07.2021.
//

extension HTTPRequest {

    var endpoint: String {
        "https://api.chucknorris.io/jokes"
    }

    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}

enum APIRequest {

    struct Categories: HTTPRequest {

        typealias Response = [APIResponse.Category]

        let method: HTTPMethod = .GET
        let path: String = "/categories"
    }

    struct RandomJoke: HTTPRequest {
        
        typealias Response = APIResponse.Joke

        let method: HTTPMethod = .GET
        let path: String

        init(category: String? = nil) {
            path = "/random\(category.map { "?category=\($0)" } ?? "")"
        }
    }
}
