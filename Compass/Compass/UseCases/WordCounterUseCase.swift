//
//  WordCounterUseCase.swift
//  Compass
//
//  Created by Matias Roldan on 07/06/2024.
//

import Foundation
import Combine

protocol WordCounterUseCaseProtocol {
    func getWords() -> AnyPublisher<Result<[String: Int], Error>, Never>
}

class WordCounterUseCase: WordCounterUseCaseProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getWords() -> AnyPublisher<Result<[String: Int], Error>, Never> {
        return networkService
            .loadString(path: .demo)
            .map { data in
                let words = data.components(
                    separatedBy: CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
                )
                
                let filteredWords = words.filter { !$0.isEmpty }
                var wordCount: [String: Int] = [:]
                
                for word in filteredWords {
                    wordCount[word, default: 0] += 1
                }
                
                return .success(wordCount)
            }
            .catch { error -> AnyPublisher<Result<[String: Int], Error>, Never> in .just(.failure(error))
            }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
