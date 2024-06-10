//
//  State.swift
//  Compass
//
//  Created by Matias Roldan on 07/06/2024.
//

import Foundation

enum State: Equatable {
    case empty
    case loading
    case loadedEveryCharacter([Character])
    case loadedEveryCharacterError
    case loadedWordsCounter([String: Int])
    case loadedWordsCounterError
}
