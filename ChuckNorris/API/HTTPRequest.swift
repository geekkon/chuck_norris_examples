//
//  HTTPRequest.swift
//  ChuckNorris
//
//  Created by Dim on 15.07.2021.
//

enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
    case DELETE
}

protocol HTTPRequest: Equatable {

    associatedtype Response: Decodable

    var endpoint: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
}

extension HTTPRequest {

    var parameters: [String: Any]? {
        nil
    }
}
