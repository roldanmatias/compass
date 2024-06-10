//
//  TrackingProtocol.swift
//  Compass
//
//  Created by Matias Roldan on 08/06/2024.
//

import Foundation

protocol TrackingProtocol {
    func logEvent(_ name: String)
    func logEvent(_ name: String, parameters: [String: AnyObject])
    func logError(_ error: Error)
}
