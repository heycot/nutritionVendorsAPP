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
    
    func updateView() {
        setUpUI()
        
        itemImage.image = UIImage(named: "secondBKImage")
        itemName.text = "Táo"
        itemPrice.text = "50.000 VND"
        numberOfReview.text = "( \(100))"
        itemRating.rating = 2.49
        
    }
    
    func setUpUI() {
        itemRating.settings.fillMode = .precise
        itemRating.settings.updateOnTouch = false
    }

}
