//
//  TrackingMock.swift
//  CompassTests
//
//  Created by Matias Roldan on 09/06/2024.
//

import Foundation
@testable import Compass

final class TrackingMock: TrackingProtocol {
    
    private(set) var logEventWasCalled = 0
    private(set) var logErrorWasCalled = 0
    
    func logEvent(_ name: String) {
        logEventWasCalled += 1
    }
    
    func logEvent(_ name: String, parameters: [String : AnyObject]) {
        logEventWasCalled += 1
    }
    
    func logError(_ error: Error) {
        logErrorWasCalled += 1
    }
}
