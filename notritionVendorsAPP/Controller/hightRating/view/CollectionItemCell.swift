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
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemRating: CosmosView!
    @IBOutlet weak var numberOfReview: UILabel!
    
//    lazy var cosmosView: CosmosView = {
//        var view = CosmosView()
//        return view
//    }()
    
    func updateView(shopItemRe: ShopItemResponse) {
        setUpUI()
        
        let urlStr = BASE_URL_IMAGE + shopItemRe.avatar! + ".jpg"
        setupItemImage(urlStr: urlStr)
        itemName.text = shopItemRe.name
        itemPrice.text = "VND " + String(shopItemRe.price!)
        numberOfReview.text = "(" + String(shopItemRe.comment_number!)  + ")"
        itemRating.rating = shopItemRe.rating! 
        
    }
    
    
    func setUpUI() {
        itemRating.settings.fillMode = .precise
        itemRating.settings.updateOnTouch = false
        
//        itemImage.image = UIImage(named: "secondBKImage")
//        itemImage.contentMode = .scaleAspectFill
//        itemImage.clipsToBounds = true
    }
    
    func setupItemImage(urlStr: String) {
        itemImage.loadImageUsingUrlString(urlString: urlStr)
    }
}
