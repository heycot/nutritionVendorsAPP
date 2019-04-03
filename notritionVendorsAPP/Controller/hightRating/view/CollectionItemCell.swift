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
//    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemRating: CosmosView!
    @IBOutlet weak var numberOfReview: UILabel!
    
//    lazy var cosmosView: CosmosView = {
//        var view = CosmosView()
//        return view
//    }()
    
    func updateView(shopItemRe: ShopItemResponse) {
        setUpUI()
        
        let urlStr = BASE_URL_IMAGE + shopItemRe.avatar! 
        setupItemImage(urlStr: urlStr)
        itemName.text = shopItemRe.name! + " - " + shopItemRe.shop_name!
//        itemPrice.text = "VND " + String(shopItemRe.price!)
        numberOfReview.text = "(" + String(shopItemRe.comment_number!)  + ")"
        
        if shopItemRe.comment_number! == 0 {
            itemRating.rating = 0.0
        } else {
            itemRating.rating = shopItemRe.rating! 
        }
        
    }
    
    func setUpUI() {
        itemRating.settings.fillMode = .precise
        itemRating.settings.updateOnTouch = false
    }
    
    func setupItemImage(urlStr: String) {
        itemImage.loadImageUsingUrlString(urlString: urlStr)
    }
}
