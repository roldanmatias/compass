//
//  wordsUseCaseMock.swift
//  CompassTests
//
//  Created by Matias Roldan on 09/06/2024.
//

import Foundation
import Combine
@testable import Compass

final class WordCounterUseCaseMock: WordCounterUseCaseProtocol {
    var words: [String : Int]?

    func getWords() -> AnyPublisher<Result<[String : Int], Error>, Never> {
        guard let words = words else {
            return .just(.failure(NetworkError.invalidResponse))
        }
        
        return .just(.success(words))
    }
}
