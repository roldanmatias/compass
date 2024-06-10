//
//  AppCoordinator.swift
//  Compass
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToHome()
    }
        
    func goToHome(){
        let coordinator = HomeCoordinator.init(navigationController: navigationController)
        coordinator.parentCoordinator = self
        children.append(coordinator)
        
        coordinator.start()
    }
}
