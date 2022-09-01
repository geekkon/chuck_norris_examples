//
//  HTTPService.swift
//  ChuckNorris
//
//  Created by Dim on 15.07.2021.
//

import Foundation

class HTTPService {

    // can inject HTTPClient to easy mocking in tests
    // can inject custom decoder

    func dispatch<R: HTTPRequest>(
        _ httpRequest: R,
        completion: @escaping (Result<R.Response, Error>) -> Void
    ) {

        guard let request = URLRequest(httpRequest) else {
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error { // TODO: for debug only
                fatalError(error.localizedDescription)
            }

            guard let response = response as? HTTPURLResponse else {
                return
            }

            if 200...299 ~= response.statusCode {
                data.flatMap { HTTPService.handle($0, completion: completion) }
            } else {
                fatalError("Unhandled status code")
            }
        }
        .resume()
    }
}


private extension HTTPService {

    static func handle<T: Decodable>(_ data: Data, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(
                    .success(result)
                )
            }
        } catch {
            handle(error, completion: completion)
        }
    }

    static func handle<T: Decodable>(_ error: Error, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.main.async {
            completion(
                .failure(error)
            )
        }
    }
}

