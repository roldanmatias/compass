//
//  Every10thCharacterUseCase.swift
//  Compass
//
//  Created by Matias Roldan on 07/06/2024.
//

import Foundation
import Combine

protocol EveryCharacterUseCaseProtocol {
    func getCharacters(every: Int) -> AnyPublisher<Result<[Character], Error>, Never>
}

class EveryCharacterUseCase: EveryCharacterUseCaseProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getCharacters(every: Int) -> AnyPublisher<Result<[Character], Error>, Never> {        
        return networkService
            .loadString(path: .demo)
            .map { data in
                let characters = Array(data)
                var result: [Character] = []

                for index in stride(from: every - 1, to: characters.count, by: every) {
                    result.append(characters[index])
                }
                
                return .success(result) 
            }
            .catch { 
                error -> AnyPublisher<Result<[Character], Error>, Never> in .just(.failure(error))
            }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
