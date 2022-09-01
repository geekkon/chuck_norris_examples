//
//  APIResponse.swift
//  ChuckNorris
//
//  Created by Dim on 15.07.2021.
//

import Foundation

enum APIResponse {

    typealias Category = String

    struct Joke: Decodable {
        let icon_url : String
        let id : String
        let url : String
        let value : String
    }
}
