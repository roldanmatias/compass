//
//  CustomTableViewCell.swift
//  Compass
//
//  Created by Matias Roldan on 08/06/2024.
//

import UIKit
import Combine

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    func load(info: RequestInfo) {
        nameLabel.text = info.text
        
        switch info.state {
        case .empty:
            statusLabel.text = String(localized: "not_loaded")
            accessoryType = .none
            activityIndicator.stopAnimating()
        case .error:
            statusLabel.text = String(localized: "loading_error")
            accessoryType = .none
            activityIndicator.stopAnimating()
        case .loading:
            statusLabel.text = String(localized: "loading")
            accessoryType = .none
            activityIndicator.startAnimating()
        case .loaded:
            statusLabel.text = String(localized: "loaded")
            accessoryType = .disclosureIndicator
            activityIndicator.stopAnimating()
        }
    }
}
