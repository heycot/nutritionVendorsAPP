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
        
        let urlStr = BASE_URL_IMAGE + shopItemRe.avatar! 
        setupItemImage(urlStr: urlStr)
        itemName.text = shopItemRe.name! + " - " + shopItemRe.shop_name!
        
        itemRating.rating = shopItemRe.rating! 
        itemRating.text = "(" + String(shopItemRe.comment_number!)  + ")"
        
    }
    
    func setUpUI() {
        itemRating.settings.fillMode = .precise
        itemRating.settings.updateOnTouch = false
    }
    
    func setupItemImage(urlStr: String) {
        itemImage.loadImageUsingUrlString(urlString: urlStr)
    }
}
