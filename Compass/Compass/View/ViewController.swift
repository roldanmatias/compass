//
//  ViewController.swift
//  Compass
//
//  Created by Matias Roldan on 06/06/2024.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var demoLabel: UILabel!
    @IBOutlet weak var requestDataButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    enum InfoRow: Int {
        case everyCharacter
        case wordsCounter
    }
    
    private enum Constant {
        static let detailSegueIdentifier = "detail"
        static let cellIdentifier = "Cell"
    }
    
    private var viewModel = Factory.createViewModel()
    private var cancellables: Set<AnyCancellable> = .init()
    private var requests: [RequestInfo] = []
    private var characters: [Character]?
    private var wordsCounter: [String: Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        demoLabel.text = String(localized: "demo_description")
        requestDataButton.setTitle(String(localized: "request_button"), for: .normal)
        requestDataButton.accessibilityIdentifier = "btnRequestData"
        
        showRequests()
        subscribeToViewModel()   
    }
    
    @IBAction func requestData(_ sender: Any) {
        requestDataButton.isHidden = true
        viewModel.send(.requestData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard 
            segue.identifier == Constant.detailSegueIdentifier,
            let collectionViewController = segue.destination as? CollectionViewController,
            let infoRow = sender as? InfoRow
        else {
            return
        }
        
        switch infoRow {
        case .everyCharacter:
            collectionViewController.data = characters?.map { String($0) }
            collectionViewController.title = String(localized: "every_10th_character")
        case .wordsCounter:
            collectionViewController.data = wordsCounter?.map { (key: String, value: Int) in
                "\(key) = \(value)"
            }
            collectionViewController.title = String(localized: "occurrence_unique_word")
        }
    }
}

private extension ViewController {
    
    func showRequests() {
        let every10thCharacterInfo = RequestInfo(
            text: String(localized: "every_10th_character"), 
            state: .empty
        )
        requests.append(every10thCharacterInfo)
        
        let wordsCounterInfo = RequestInfo(
            text: String(localized: "occurrence_unique_word"), 
            state: .empty
        )
        requests.append(wordsCounterInfo)
        
        tableView.reloadData()
    }
    
    func subscribeToViewModel() {
        viewModel.$state.sink { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .empty:
                break
            case .loading:
                self.showLoadingStates()
            case .loadedEveryCharacter(let everyCharacter):
                self.showEveryCharacter(everyCharacter)
            case .loadedWordsCounter(let wordsCounter):
                self.showWordsCounter(wordsCounter)
            case .loadedEveryCharacterError:
                self.requests[InfoRow.everyCharacter.rawValue].state = .loaded
            case .loadedWordsCounterError:
                self.requests[InfoRow.wordsCounter.rawValue].state = .loaded
            }
            
            self.tableView.reloadData()
        }
        .store(in: &cancellables)
    }
    
    func showLoadingStates() {
        for i in 0..<requests.count {
            requests[i].state = .loading
        }
    }
    
    func showEveryCharacter(_ characters: [Character]) {
        self.characters = characters
        requests[InfoRow.everyCharacter.rawValue].state = .loaded
    }
    
    func showWordsCounter(_ wordsCounter: [String: Int]) {
        self.wordsCounter = wordsCounter
        requests[InfoRow.wordsCounter.rawValue].state = .loaded
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath) as? CustomTableViewCell 
        else { return UITableViewCell()}
        
        let info = requests[indexPath.row]
        cell.load(info: info)
        cell.accessibilityIdentifier = "cell\(indexPath.row)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = requests[indexPath.row]
        
        guard 
            info.state == .loaded,
            let infoRow = InfoRow(rawValue: indexPath.row) 
        else { return } 
        
        performSegue(withIdentifier: Constant.detailSegueIdentifier, sender: infoRow)
    }
}
