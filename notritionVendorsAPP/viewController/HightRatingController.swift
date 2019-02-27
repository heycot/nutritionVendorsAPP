//
//  HightRatingController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class HightRatingController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var itemCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionCell()
        createSearchBar()
        
        itemCollection.delegate = self
        itemCollection.dataSource = self
//        let flow = collectioitemCollectionnView.collectionViewLayout as! UICollectionViewFlowLayout
//        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)

        
    }
    
    func createCollectionCell() {
        
//        itemCollection.register(UINib.init(nibName: "CollectionItemCell", bundle: nil), forSupplementaryViewOfKind: "CollectionItemCell", withReuseIdentifier: "ItemCell")
        itemCollection.register(UINib.init(nibName: "CollectionItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
//           boardCollectionView.register(UINib(nibName: Constants.CellIdentifiers.cardCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.CellIdentifiers.cardCollectionViewCell)
        
        if let flowLayout = itemCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 250, height: 250)
        }
        
    
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search here"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }

}

extension HightRatingController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? CollectionItemCell {
            cell.updateView()
            
            return cell
        }
        return CollectionItemCell()
    }
    
}


extension HightRatingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        <#code#>
//    }
}
