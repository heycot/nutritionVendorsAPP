//
//  HightRatingController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class HightRatingController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var itemCollection: UICollectionView!
    
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearchBar()
        
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell {
            
        }
        
        return cell
    }
    
    
}
