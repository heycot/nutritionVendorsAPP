//
//  CategoryCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/14/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var itemImage: CustomImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
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
        name.text = item.name! + " - " + item.shop_name!
        address.text = item.address!
        rating.rating = item.rating!
        rating.text = " (" + String(item.comment_number!) + ")"
    }
    
    func setupView() {
        rating.settings.updateOnTouch = false
        rating.settings.fillMode = .precise
        
    }
}
