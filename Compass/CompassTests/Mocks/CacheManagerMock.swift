//
//  CacheManagerMock.swift
//  CompassTests
//
//  Created by Matias Roldan on 09/06/2024.
//

import Foundation
@testable import Compass

final class CacheManagerMock: CacheManagerProtocol {

    var data: Data?
    
    private(set) var saveResponseWasCalled = false
    private(set) var loadResponseWasCalled = false
    
    init() {
    }

    func saveResponse(for url: URL, data: Data) {
        saveResponseWasCalled = true
    }

    func loadResponse(for url: URL) -> Data? {
        loadResponseWasCalled = true
        return data
    }
    
    func reset() {
        saveResponseWasCalled = false
        loadResponseWasCalled = false
        data = nil
    }
}
