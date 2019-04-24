//
//  ItemInShopCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/15/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos

class ItemInShopCell: UITableViewCell {

    @IBOutlet weak var itemImage: CustomImageView!
    @IBOutlet weak var itemname: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemRating: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(item: ShopItemResponse) {
        setupView()
        
        if let avatar = item.avatar {
            itemImage.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + avatar)
        }
        itemname.text = String(item.name!)
        itemPrice.text = "price: VND " + String(item.price!)
        itemRating.rating = item.rating!
    }
    
    func setupView() {
        itemRating.settings.updateOnTouch = false
        itemRating.settings.fillMode = .precise
    }

}
