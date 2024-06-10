//
//  EveryCharacterUseCaseMock.swift
//  CompassTests
//
//  Created by Matias Roldan on 09/06/2024.
//

import Foundation
import Combine
@testable import Compass

final class EveryCharacterUseCaseMock: EveryCharacterUseCaseProtocol {
    
    var characters: [Character]?
    
    func getCharacters(every: Int) -> AnyPublisher<Result<[Character], Error>, Never> {
        guard let characters = characters else {
            return .just(.failure(NetworkError.invalidResponse))
        }
        
        return .just(.success(characters))
    }
}
