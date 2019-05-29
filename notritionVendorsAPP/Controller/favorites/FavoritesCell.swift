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
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView(item: FavoritesResponse) {
        itemImage.displayImage(folderPath: ReferenceImage.shopItem.rawValue + "\(item.shop_item_id ?? "")/\(item.avatar ?? "")")
        itemName.text = (item.shop_item_name ?? "") + " - " + (item.shop_name ?? "")
        address.text = item.address ?? ""
        rating.rating = item.rating ?? 3.0
        
        setupView() 
    }
    
    func setupView() {
        rating.settings.fillMode = .precise
        rating.settings.updateOnTouch = false
    }

}
