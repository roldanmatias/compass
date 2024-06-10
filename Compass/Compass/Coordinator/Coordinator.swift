//
//  Coordinator.swift
//  Compass
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}
