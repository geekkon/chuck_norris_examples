//
//  Created by Nikita Borodulin on 05.09.2022.
//

import Get
import Foundation

public typealias Request = Get.Request
public typealias Response = Get.Response

public protocol APIClient: Sendable {

  @discardableResult func send<T: Decodable>(
    _ request: Request<T>,
    delegate: URLSessionDataDelegate?,
    configure: ((inout URLRequest) throws -> Void)?
  ) async throws -> Response<T>
}

public extension APIClient {

  @discardableResult func send<T: Decodable>(
    _ request: Request<T>,
    delegate: URLSessionDataDelegate? = nil,
    configure: ((inout URLRequest) throws -> Void)? = nil
  ) async throws -> Response<T> {
    try await send(request, delegate: delegate, configure: configure)
  }
}
