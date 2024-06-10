//
//  CacheManagerProtocol.swift
//  Compass
//
//  Created by Matias Roldan on 09/06/2024.
//

import Foundation

protocol CacheManagerProtocol {
    func saveResponse(for url: URL, data: Data)
    func loadResponse(for url: URL) -> Data?
}
