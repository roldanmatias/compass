//
//  CompassTests.swift
//  CompassTests
//
//  Created by Matias Roldan on 06/06/2024.
//

import XCTest
import Combine
@testable import Compass

final class ViewModelTests: XCTestCase {

    private var cancellables: [AnyCancellable] = []
    
    override func setUpWithError() throws {
        
    }

    func test_requestDataSuccessfully() {
        // Given
        let expectation = self.expectation(description: "WordCounterUseCaseExpectation")
        var loadingWasCalling = false
        var loadedEveryCharacterWasCalling = false
        var loadedWordsCounterWasCalling = false
        var characterResult: [Character]?
        var wordsResult: [String: Int]?
        
        let characterUseCase = EveryCharacterUseCaseMock()
        characterUseCase.characters = ["T", "e", "s", "t"]
        let wordsUseCase = WordCounterUseCaseMock()
        wordsUseCase.words = ["T": 2, "e": 1, "s": 1]
        let tracking = TrackingMock()
        
        let viewModel = ViewModel(
            charactersUseCase: characterUseCase, 
            wordsUseCase: wordsUseCase, 
            tracking: tracking
        )
        viewModel.$state.sink { state in
            switch state {
            case .empty, .loadedEveryCharacterError, .loadedWordsCounterError:
                break
            case .loading:
                loadingWasCalling = true
            case .loadedEveryCharacter(let characters):
                loadedEveryCharacterWasCalling = true
                characterResult = characters
                
                if loadedWordsCounterWasCalling {
                    expectation.fulfill()
                }
            case .loadedWordsCounter(let words):
                loadedWordsCounterWasCalling = true
                wordsResult = words
                
                if loadedEveryCharacterWasCalling {
                    expectation.fulfill()
                }
            }
            
        }
        .store(in: &cancellables)
        
        // When
        viewModel.send(.requestData)
        
        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssert(loadingWasCalling)
        XCTAssert(loadedEveryCharacterWasCalling)
        XCTAssert(loadedWordsCounterWasCalling)
        XCTAssertEqual(characterResult, characterUseCase.characters)
        XCTAssertEqual(wordsResult, wordsUseCase.words)
        XCTAssertEqual(tracking.logEventWasCalled, 3)
    }

    func test_requestDataError() {
        // Given
        let expectation = self.expectation(description: "WordCounterUseCaseExpectation")
        var loadingWasCalling = false
        var loadedEveryCharacterWasCalled = false
        var loadedWordsCounterWasCalled = false
        var loadedWordsCounterErrorWasCalled = false
        var loadedEveryCharacterErrorWasCalled = false
        let characterUseCase = EveryCharacterUseCaseMock()
        let wordsUseCase = WordCounterUseCaseMock()
        let tracking = TrackingMock()
        
        let viewModel = ViewModel(
            charactersUseCase: characterUseCase, 
            wordsUseCase: wordsUseCase, 
            tracking: tracking
        )
        viewModel.$state.sink { state in
            switch state {
            case .empty:
                break
            case .loadedEveryCharacterError:
                loadedEveryCharacterErrorWasCalled = true
                
                if loadedWordsCounterErrorWasCalled {
                    expectation.fulfill()
                }
            case .loadedWordsCounterError:
                loadedWordsCounterErrorWasCalled = true
                
                if loadedEveryCharacterErrorWasCalled {
                    expectation.fulfill()
                }
            case .loading:
                loadingWasCalling = true
            case .loadedEveryCharacter(_):
                loadedEveryCharacterWasCalled = true
            case .loadedWordsCounter(_):
                loadedWordsCounterWasCalled = true
            }
            
        }
        .store(in: &cancellables)
        
        // When
        viewModel.send(.requestData)
        
        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssert(loadingWasCalling)
        XCTAssertFalse(loadedEveryCharacterWasCalled)
        XCTAssertFalse(loadedWordsCounterWasCalled)
        XCTAssert(loadedEveryCharacterErrorWasCalled)
        XCTAssert(loadedWordsCounterErrorWasCalled)
        XCTAssertEqual(tracking.logErrorWasCalled, 2)
    }
}
