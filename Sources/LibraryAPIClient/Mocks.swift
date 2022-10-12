//
//  Created by Nikita Borodulin on 05.09.2022.
//

import Foundation
import Get
import XCTestDynamicOverlay

public extension APIClient where Self == UnimplementedAPIClient {

  static var unimplemented: APIClient {
    UnimplementedAPIClient()
  }
}

public struct UnimplementedAPIClient: APIClient {

  public func send<T>(
    _ request: Request<T>,
    delegate: URLSessionDataDelegate?,
    configure: ((inout URLRequest) throws -> Void)?
  ) async throws -> Response<T> where T : Decodable {
    XCTFail("\(Self.self).send is unimplemented")
    return .init(
      value: try JSONDecoder().decode(T.self, from: .init()),
      data: .init(),
      response: .init(),
      task: URLSession.shared.dataTask(with: URLRequest(url: .init(string: "google.com")!))
    )
  }
}
