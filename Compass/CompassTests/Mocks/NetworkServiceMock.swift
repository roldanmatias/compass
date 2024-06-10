//
//  NetworkServiceMock.swift
//  CompassTests
//
//  Created by Matias Roldan on 09/06/2024.
//

import Foundation
import Combine
@testable import Compass

final class NetworkServiceMock: NetworkServiceProtocol {
    var error: NetworkError?
    var response: String?
    
    func loadString(path: Compass.NetworkPath) -> AnyPublisher<String, Error> {
        if let response = response {
            return .just(response)
        } else if let error = error {
            return .fail(error)
        } else {
            return .fail(NetworkError.invalidRequest)
        }
    }
    
    func reset() {
        error = nil
        response = nil
    }
}
