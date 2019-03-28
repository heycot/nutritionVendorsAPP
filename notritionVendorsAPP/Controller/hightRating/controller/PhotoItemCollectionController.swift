//
//  PhotoItemCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class PhotoItemCollectionController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var documents = [DocumentResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
    }
}


extension PhotoItemCollectionController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.photoItem.rawValue, for: indexPath) as! PhotoItemCell
        
        cell.updateView(name: documents[indexPath.row].link!)
        
        return cell
    }
}
