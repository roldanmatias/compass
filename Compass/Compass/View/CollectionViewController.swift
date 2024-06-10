//
//  CollectionViewController.swift
//  Compass
//
//  Created by Matias Roldan on 06/06/2024.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    var data: [String]?
    
    private enum Constant {
        static let reuseIdentifier = "Cell"
        static let cellBorderWidth = 1.0 
        static let cellCornerRadius = 4.0
        static let cellBorderColor = UIColor.gray.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(
            UICollectionViewCell.self, 
            forCellWithReuseIdentifier: Constant.reuseIdentifier
        )
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.reuseIdentifier, for: indexPath)
    
        var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = data?[indexPath.row] ?? ""
        
        cell.contentConfiguration = contentConfiguration
        cell.layer.borderColor = Constant.cellBorderColor
        cell.layer.borderWidth = Constant.cellBorderWidth
        cell.layer.cornerRadius = Constant.cellCornerRadius
        
        return cell
    }
}
