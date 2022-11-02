//
//  HTTPService.swift
//  ChuckNorris
//
//  Created by Dim on 15.07.2021.
//

import Combine
import Foundation

class HTTPService {

    // can inject HTTPClient to easy mocking in tests
    // can inject custom decoder
    func publisher<R: HTTPRequest>(for httpRequest: R) -> AnyPublisher<R.Response, Error> {

        // TODO: Emmit error
        guard let request = URLRequest(httpRequest) else {
            return Empty().eraseToAnyPublisher()
        }

        // TODO: Handle HTTP & decoding errors
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: R.Response.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
