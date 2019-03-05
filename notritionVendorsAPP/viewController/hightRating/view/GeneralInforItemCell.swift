//
//  GeneralInforItemCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class GeneralInforItemCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemComments: UITextField!
    @IBOutlet weak var itemPhotos: UITextField!
    @IBOutlet weak var itemFavorites: UITextField!
    @IBOutlet weak var itemRating: UITextField!
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//    
    
    func updateView(image_name: String, item_name: String, item_comment: Int, item_photo: Int, item_favorites: Int, item_rating: Double) {
        itemImage.image    = UIImage(named: image_name)
        itemName.text      = item_name
        itemComments.text  = String(item_comment)
        itemPhotos.text    = String(item_photo)
        itemFavorites.text = String(item_favorites)
        itemRating.text    = String(item_rating)
        
        customUI()
    }
    
    func customUI() {
        itemName.setBottomBorder(color: .lightGray)
    }
    
}
