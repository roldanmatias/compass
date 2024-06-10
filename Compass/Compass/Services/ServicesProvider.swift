//
//  ServicesProvider.swift
//  Compass
//
//  Created by Matias Roldan on 07/06/2024.
//

import Foundation

class ServicesProvider {
    let network: NetworkServiceProtocol

    static func defaultProvider() -> ServicesProvider {
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let tracking = Tracking()
        let cacheManager = CacheManager(fileManager: FileManager.default, tracking: tracking)
        let network = NetworkService(session: session, cacheManager: cacheManager)
        return ServicesProvider(network: network)
    }

    init(network: NetworkServiceProtocol) {
        self.network = network
    }
}
