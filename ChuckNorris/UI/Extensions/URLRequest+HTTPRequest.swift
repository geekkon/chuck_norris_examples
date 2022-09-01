//
//  URLRequest+HTTPRequest.swift
//  ChuckNorris
//
//  Created by Dim on 15.07.2021.
//

import Foundation

extension URLRequest {

    init?<R: HTTPRequest>(_ request: R) {

        guard let url = URL(string: request.endpoint + request.path) else {
            return nil
        }

        self.init(url: url)

        allHTTPHeaderFields = request.headers
        httpMethod = request.method.rawValue
        httpBody = request.parameters.flatMap {
            try? JSONSerialization.data(
                withJSONObject: $0,
                options: []
            )
        }
    }
}
