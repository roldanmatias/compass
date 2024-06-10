//
//  Every10thCharacterUseCaseTests.swift
//  CompassTests
//
//  Created by Matias Roldan on 09/06/2024.
//

import XCTest
import Combine
@testable import Compass

final class EveryCharacterUseCaseTests: XCTestCase {

    private let networkService = NetworkServiceMock()
    private var cancellables: [AnyCancellable] = []
    private var characters: [Character]?
    private var error: NetworkError?
    
    override func setUpWithError() throws {
        networkService.reset()
        characters = nil
        error = nil
    }
    
    func test_getCharacterSuccessfully() {
        // Given
        let expectation = self.expectation(description: "EveryCharacterUseCaseExpectation")
        let everyCharacterUseCase = EveryCharacterUseCase(networkService: networkService)
        networkService.response = "Character Unit Test. Character Unit Test."

        // When
        everyCharacterUseCase
            .getCharacters(every: 10)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    XCTFail()
                default:
                    break
                }
            }, receiveValue: { [weak self] result in
                do {
                    self?.characters = try result.get()
                    expectation.fulfill()
                } catch {
                    XCTFail()
                }
            })
            .store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        guard let characters = characters else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(characters[0], " ")
        XCTAssertEqual(characters[1], ".")
        XCTAssertEqual(characters[2], "r")
        XCTAssertEqual(characters[3], "t")
    }
    
    func test_getCharacterError() {
        // Given
        var result: Result<[Character], Error>!
        let expectation = self.expectation(description: "EveryCharacterUseCaseExpectation")
        let everyCharacterUseCase = EveryCharacterUseCase(networkService: networkService)
        networkService.error = NetworkError.invalidResponse

        // When
        everyCharacterUseCase
            .getCharacters(every: 10)
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
