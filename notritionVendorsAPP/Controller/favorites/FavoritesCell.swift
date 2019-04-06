//
//  FavoritesCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/6/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos

class FavoritesCell: UITableViewCell {

    @IBOutlet weak var itemImage: CustomImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView(item: ShopItemResponse) {
        itemImage.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + item.avatar!)
        itemName.text = item.name!
        shopName.text = item.shop_name!
        if item.comment_number! == 0 {
            rating.rating = 0.0
        } else {
            rating.rating = item.rating!
        }
        rating.text = "(" + String(item.comment_number!) + ")"
        
        setupView() 
    }
    
    func setupView() {
        rating.settings.fillMode = .precise
        rating.settings.updateOnTouch = false
    }

}
