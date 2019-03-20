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

    @IBOutlet weak var itemImage: UIImageView!
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
        var avatar = "secondBKImage"
        if shopItemRe.avatar == nil {
            avatar = shopItemRe.avatar ?? "secondBKImage"
        }
        itemImage.image = UIImage(named: avatar)
        itemName.text = shopItemRe.name
        itemPrice.text = "VND " + String(shopItemRe.price!)
        numberOfReview.text = "(" + String(shopItemRe.comment_number!)  + ")"
        itemRating.rating = shopItemRe.rating! ?? 1.0
        
    }
    
    func setUpUI() {
        itemRating.settings.fillMode = .precise
        itemRating.settings.updateOnTouch = false
    }

}
