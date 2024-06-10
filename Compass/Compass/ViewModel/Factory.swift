//
//  Factory.swift
//  Compass
//
//  Created by Matias Roldan on 06/06/2024.
//

import Foundation

class Factory {
    static func createViewModel() -> ViewModel {
        let tracking = Tracking()
        let networkService = ServicesProvider.defaultProvider().network
        let charactersUseCase = EveryCharacterUseCase(networkService: networkService)
        let wordsUseCase = WordCounterUseCase(networkService: networkService)
        return ViewModel(
            charactersUseCase: charactersUseCase, 
            wordsUseCase: wordsUseCase,
            tracking: tracking
        )
    }
}
