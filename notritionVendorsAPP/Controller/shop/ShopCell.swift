//
//  ShopCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos

class ShopCell: UITableViewCell {
    
    @IBOutlet weak var shopImage: CustomImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var infor: UILabel!
    @IBOutlet weak var shopRating: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(shop: ShopResponse, isNewest: Bool) {
        setupView()
        
        shopImage.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + shop.avatar!)
        shopName.text = shop.name!
        shopRating.rating = shop.rating!
        if isNewest {
            infor.text = shop.create_date?.timeAgoDisplay()
        } else {
            infor.text = shop.distance!
        }
    }
    
    func setupView() {
        shopRating.settings.updateOnTouch = false
        shopRating.settings.fillMode = .precise
    }

}
