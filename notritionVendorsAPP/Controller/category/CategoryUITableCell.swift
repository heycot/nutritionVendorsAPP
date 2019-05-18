//
//  CategoryCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/14/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos

class CategoryUITableCell: UITableViewCell {

    @IBOutlet weak var itemImage: CustomImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView(item: ShopItemResponse) {
        setupView()
        
//        itemImage.loadImageFromFirebase(folder: ReferenceImage.shopItem.rawValue + item.id +  item.avatar ?? "")
        name.text = item.name! + " - " + item.shop_name!
//        address.text = item.address!
        rating.rating = item.rating!
        rating.text = " (" + String(item.comment_number!) + ")"
    }
    
    func setupView() {
        rating.settings.updateOnTouch = false
        rating.settings.fillMode = .precise
        
    }
}
