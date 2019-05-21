//
//  SearchCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/13/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos

class SearchCell: UITableViewCell {
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
    
    func updateView(item: SearchResponse) {
        setupView()
        var folder = ""
        
        if item.is_shop == 0 {
            folder = ReferenceImage.shopItem.rawValue + "\(item.entity_id ?? "")/\(item.avatar ?? "")"
        } else{
            folder = ReferenceImage.shop.rawValue + "\(item.entity_id ?? "")/\(item.avatar ?? "")"
        }
        
        print("folder images :  \(folder)")
        itemImage.displayImage(folderPath: folder)
        name.text = item.entity_name!
        address.text = item.address!
        rating.rating = item.rating!
        rating.text = " (" + String(item.comment_number!) + ")"
    }
    
    func setupView() {
        rating.settings.updateOnTouch = false
        rating.settings.fillMode = .precise
        
    }

}
