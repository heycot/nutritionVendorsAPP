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
    @IBOutlet weak var itemRating: UIView!
    
//    lazy var cosmosView: CosmosView = {
//        var view = CosmosView()
//        return view
//    }()
    
    func updateView() {
        itemImage.image = UIImage(named: "thirdBKImage")
        itemName.text = "Táo"
        itemPrice.text = "50.000 VND"
        itemRating.setButtomBorderRadious()
    }

}
