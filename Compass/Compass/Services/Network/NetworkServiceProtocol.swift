//
//  NetworkServiceProtocol.swift
//  Compass
//
//  Created by Matias Roldan on 07/06/2024.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
}

enum NetworkPath: String {
    case demo = "https://www.compass.com/about/"
}

protocol NetworkServiceProtocol {
    func loadString(path: NetworkPath) -> AnyPublisher<String, Error>
}
