//
//  ViewModelProtocol.swift
//  Compass
//
//  Created by Matias Roldan on 06/06/2024.
//

import Foundation

protocol ViewModelProtocol {
    var state: State { get }
    func send(_ event: Event)
}
