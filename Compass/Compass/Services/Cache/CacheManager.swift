//
//  CacheManager.swift
//  Compass
//
//  Created by Matias Roldan on 07/06/2024.
//

import Foundation

class CacheManager: CacheManagerProtocol {
    private let cacheDirectory: URL
    private let tracking: TrackingProtocol

    init(fileManager: FileManager, tracking: TrackingProtocol) {
        self.tracking = tracking
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        
        if urls.count > 0 {
            cacheDirectory = urls[0]
        } else {
            fatalError("Failed to get url from FileManager.")
        }
    }

    func saveResponse(for url: URL, data: Data) {
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        do {
            try data.write(to: filePath)
            tracking.logEvent("Data saved to cache")
        } catch {
            tracking.logError(error)
        }
    }

    func loadResponse(for url: URL) -> Data? {
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        do {
            let data = try Data(contentsOf: filePath)
            tracking.logEvent("Data loaded from cache")
            return data
        } catch {
            tracking.logError(error)
            return nil
        }
    }
}
