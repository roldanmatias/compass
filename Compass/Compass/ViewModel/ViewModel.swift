//
//  ViewModel.swift
//  Compass
//
//  Created by Matias Roldan on 06/06/2024.
//

import Foundation
import Combine

final class ViewModel: ViewModelProtocol {
    
    @Published var state: State
    
    private var charactersUseCase: EveryCharacterUseCaseProtocol
    private var wordsUseCase: WordCounterUseCaseProtocol
    private var tracking: TrackingProtocol
    private var cancellables: [AnyCancellable] = []
    
    init(
        state: State = .empty, 
        charactersUseCase: EveryCharacterUseCaseProtocol,
        wordsUseCase: WordCounterUseCaseProtocol,
        tracking: TrackingProtocol
    ) {
        self.state = state
        self.charactersUseCase = charactersUseCase
        self.wordsUseCase = wordsUseCase
        self.tracking = tracking
    }

    public func send(_ event: Event) {
        switch event {
        case .requestData:
            load()
        }
    }
}

private extension ViewModel  {
    func load() {
        tracking.logEvent("ViewModel load")
        state = .loading
        getCharacters()
        getWords()
    }
    
    func getCharacters() {
        charactersUseCase.getCharacters(every: 10)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.tracking.logError(error)
                    self?.state = .loadedEveryCharacterError
                default:
                    break
                }
            }, receiveValue: { [weak self] result in
                do {
                    let characters = try result.get()
                    self?.state = .loadedEveryCharacter(characters)
                    self?.tracking.logEvent("getCharacters completed")
                } catch {
                    self?.tracking.logError(error)
                    self?.state = .loadedEveryCharacterError
                }
            })
            .store(in: &cancellables)
    }
    
    func getWords() {
        wordsUseCase.getWords()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.tracking.logError(error)
                    self?.state = .loadedWordsCounterError
                default:
                    break
                }
            }, receiveValue: { [weak self] result in
                do {
                    let words = try result.get()
                    self?.state = .loadedWordsCounter(words)
                    self?.tracking.logEvent("getWords completed")
                } catch {
                    self?.tracking.logError(error)
                    self?.state = .loadedWordsCounterError
                }
            })
            .store(in: &cancellables)
    }
}
