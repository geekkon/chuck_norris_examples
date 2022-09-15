//
//  Created by Nikita Borodulin on 04.09.2022.
//

import ComposableArchitecture
import Foundation
import Get
import XCTestDynamicOverlay

public struct LiveAPIClient: APIClient {

  private let apiClient: Get.APIClient

  public init(baseURL: URL)  {
    self.apiClient = Get.APIClient(baseURL: baseURL)
  }

  public func send<T: Decodable>(
    _ request: Request<T>,
    delegate: URLSessionDataDelegate? = nil,
    configure: ((inout URLRequest) throws -> Void)? = nil
  ) async throws -> Response<T> {
    try await apiClient.send(request, delegate: delegate, configure: configure)
  }
}
