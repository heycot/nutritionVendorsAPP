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
    
    var itemList = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        createSearchBar()
        
        itemCollection.delegate = self
        itemCollection.dataSource = self
       
    }
    
    func prepareData() {
//        var item = Item(id: 0, name: "Nho den", catalog_id: 0)
//        itemList.append(item)
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search here"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is ViewItemController {
//            let vc = segue.destination as? ViewItemController
//            vc?.item = sender as! Item
//        }
    }

}

extension HightRatingController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? CollectionItemCell {
            cell.updateView()
//            cell.setBorderRadious()
            return cell
        }
        return CollectionItemCell()
    }
    
}


extension HightRatingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.size.width - 30)/2
        return CGSize(width: cellWidth, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
}
