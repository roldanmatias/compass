//
//  WordCounterUseCaseTests.swift
//  CompassTests
//
//  Created by Matias Roldan on 09/06/2024.
//

import XCTest
import Combine
@testable import Compass

final class WordCounterUseCaseTests: XCTestCase {

    private let networkService = NetworkServiceMock()
    private var cancellables: [AnyCancellable] = []
    private var words: [String: Int]?
    private var error: NetworkError?
    
    override func setUpWithError() throws {
        networkService.reset()
        words = nil
        error = nil
    }
    
    func test_getWordsSuccessfully() {
        // Given
        let expectation = self.expectation(description: "WordCounterUseCaseExpectation")
        let wordsUseCase = WordCounterUseCase(networkService: networkService)
        networkService.response = "Unit Test Test"

        // When
        wordsUseCase.getWords()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    XCTFail()
                default:
                    break
                }
            }, receiveValue: { [weak self] result in
                do {
                    self?.words = try result.get()
                    expectation.fulfill()
                } catch {
                    XCTFail()
                }
            })
            .store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        guard let words = words else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(words["Unit"], 1)
        XCTAssertEqual(words["Test"], 2)
    }
    
    func test_getWordsError() {
        // Given
        var result: Result<[String: Int], Error>!
        let expectation = self.expectation(description: "WordCounterUseCaseExpectation")
        let wordsUseCase = WordCounterUseCase(networkService: networkService)
        networkService.error = NetworkError.invalidResponse

        // When
        wordsUseCase
            .getWords()
            .sink { value in
                result = value
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        guard case .failure = result! else {
            XCTFail()
            return
        }
    }
}
