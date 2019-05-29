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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView(item: SearchResponse) {
        var folder = ""
        
        if item.is_shop == 0 {
            folder = ReferenceImage.shopItem.rawValue + "\(item.entity_id ?? "")/\(item.avatar ?? "")"
        } else{
            folder = ReferenceImage.shop.rawValue + "\(item.entity_id ?? "")/\(item.avatar ?? "")"
        }
        
        itemImage.displayImage(folderPath: folder)
        name.text = item.entity_name ?? ""
        address.text = item.address ?? ""
    }
    

}
