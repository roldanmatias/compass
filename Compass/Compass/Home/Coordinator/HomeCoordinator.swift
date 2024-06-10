//
//  HomeCoordinator.swift
//  Compass
//
//  Created by Matias Roldan on 10/06/2024.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "ViewController"
        ) as? ViewController 
        else { 
            return
        }
        
        let tracking = Tracking()
        let networkService = ServicesProvider.defaultProvider().network
        let charactersUseCase = EveryCharacterUseCase(networkService: networkService)
        let wordsUseCase = WordCounterUseCase(networkService: networkService)
        let viewModel = ViewModel(
            charactersUseCase: charactersUseCase, 
            wordsUseCase: wordsUseCase,
            tracking: tracking
        )
        viewModel.coordinator = self    
        viewController.viewModel = viewModel

        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToDetail(data: [String], title: String) {
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "CollectionViewController"
        ) as? CollectionViewController 
        else { 
            return
        }
        
        viewController.data = data
        viewController.title = title

        navigationController.pushViewController(viewController, animated: true)
    }
}
