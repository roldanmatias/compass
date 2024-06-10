//
//  NetworkServiceTests.swift
//  CompassTests
//
//  Created by Matias Roldan on 09/06/2024.
//

import XCTest
import Combine
@testable import Compass

final class NetworkServiceTests: XCTestCase {

    private var cache = CacheManagerMock()
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(
        session: session, 
        cacheManager: cache
    )
    private let text = "text from url"
    private let cacheText = "text from cache"
    private var cancellables: [AnyCancellable] = []
    private var result: Result<String, Error>?

    override func setUpWithError() throws {
        URLProtocol.registerClass(URLProtocolMock.self)
        cache.reset()
        result = nil
    }

    func test_loadFinishedSuccessfully() {
        // Given
        let expectation = self.expectation(description: "networkServiceExpectation")
        setRequestHandler()

        // When
        networkServiceLoadString(expectation)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success(let content) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(content, text)
        XCTAssert(cache.loadResponseWasCalled)
        XCTAssert(cache.saveResponseWasCalled)
    }
    
    func test_loadFromCacheFinishedSuccessfully() {
        // Given
        let expectation = self.expectation(description: "networkServiceExpectation")
        setRequestHandler()
        cache.data = cacheText.data(using: .utf8)

        // When
        networkServiceLoadString(expectation)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success(let content) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(content, cacheText)
        XCTAssert(cache.loadResponseWasCalled)
        XCTAssertFalse(cache.saveResponseWasCalled)
    }
    
    func test_loadFinishedWithError() {
        // Given
        let expectation = self.expectation(description: "networkServiceExpectation")
        setRequestHandlerError()

        // When
        networkServiceLoadString(expectation)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        guard case .failure(let error) = result,
            let networkError = error as? NetworkError,
            case NetworkError.dataLoadingError(500, _) = networkError else {
            XCTFail()
            return
        }
    }
    
    private func setRequestHandler() {
        URLProtocolMock.requestHandler = { [weak self] request in
            let response = HTTPURLResponse(
                url: URL(string: NetworkPath.demo.rawValue)!, 
                statusCode: 200,
                httpVersion: nil, 
                headerFields: nil
            )!
            let data = self?.text.data(using: .utf8) ?? Data()
            return (response, data)
        }
    }
    
    private func setRequestHandlerError() {
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(
                url: URL(string: NetworkPath.demo.rawValue)!, 
                statusCode: 500,
                httpVersion: nil, 
                headerFields: nil
            )!
            return (response, Data())
        }
    }
    
    private func networkServiceLoadString(_ expectation: XCTestExpectation) {
        networkService
            .loadString(path: .demo)
            .map { data in
                return .success(data) 
            }
            .catch { 
                error -> AnyPublisher<Result<String, Error>, Never> in 
                    .just(.failure(error))
            }
            .sink(receiveValue: { [weak self] value in
                self?.result = value
                expectation.fulfill()
            })
            .store(in: &cancellables)
    }
}
