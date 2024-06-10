//
//  NetworkService.swift
//  Compass
//
//  Created by Matias Roldan on 07/06/2024.
//

import Foundation
import Combine

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let cacheManager: CacheManagerProtocol
    private var cancels: Set<AnyCancellable> = []
    
    init(
        session: URLSession, 
        cacheManager: CacheManagerProtocol
    ) {
        self.session = session
        self.cacheManager = cacheManager
    }
    
    func loadString(path: NetworkPath) -> AnyPublisher<String, Error> {
        guard 
            let url = URL(string: path.rawValue)
        else {
            return .fail(NetworkError.invalidRequest) 
        }
        
        if let cacheData = cacheManager.loadResponse(for: url) {
            return .just(String(data: cacheData, encoding:. utf8) ?? "")
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        return session.dataTaskPublisher(for: request)
            .mapError { _ in 
                NetworkError.invalidResponse
            }
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(NetworkError.invalidResponse)
                }

                guard 200..<300 ~= response.statusCode else {
                    return .fail(NetworkError.dataLoadingError(statusCode: response.statusCode, data: data))
                }
                return .just(data)
            }
            .compactMap {
                self.cacheManager.saveResponse(for: url, data: $0)
                return String(data: $0, encoding:. utf8)
            }
            .eraseToAnyPublisher()
    }
}
