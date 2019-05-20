//
//  CollectionItemCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class CollectionItemCell: UICollectionViewCell {

    @IBOutlet weak var itemImage: CustomImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemRating: CosmosView!
    
    
    func updateView(shopItemRe: ShopItemResponse) {
        setUpUI()
        
        setupItemImage(id: shopItemRe.id ?? "", avatar: shopItemRe.avatar ?? "")
        itemName.text = shopItemRe.name! + " - " + shopItemRe.shop_name!
        
        itemRating.rating = shopItemRe.rating! 
        itemRating.text = "(" + String(shopItemRe.comment_number!)  + ")"
        
    }
    
    func setUpUI() {
        itemRating.settings.fillMode = .precise
        itemRating.settings.updateOnTouch = false
    }
    
    func setupItemImage(id: String, avatar: String) {
        let folder = ReferenceImage.shopItem.rawValue + "\(id)/\(avatar)"
        itemImage.displayImage(folderPath: folder)
//        itemImage.loadImageFromFirebase(folder: folder)
    }
}
