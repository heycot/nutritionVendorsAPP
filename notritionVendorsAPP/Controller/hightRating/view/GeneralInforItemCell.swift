//
//  GeneralInforItemCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit



class GeneralInforItemCell: UITableViewCell {

    @IBOutlet weak var itemImage: CustomImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemComments: UITextField!
    @IBOutlet weak var itemPhotos: UIButton!
    @IBOutlet weak var itemFavorites: UITextField!
    @IBOutlet weak var itemRating: UITextField!
    @IBOutlet weak var loveBtn: UIButton!
    
    
    func updateView(item: ShopItemResponse) {
        customUI()
        
        itemImage.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + item.avatar! )
        itemName.text      = item.name ?? ""
        itemComments.text  = String((item.comments?.count) ?? 0)
        itemPhotos.titleLabel?.text    = String((item.documents?.count) ?? 0)
        itemFavorites.text = String(item.favorites_number ?? 0)
        itemRating.text    = String(format: "%.2f", item.rating ?? 0)
        
        let loveIconName = item.love_status == 0 ? "unlove" : "loved"
        loveBtn.setImage(UIImage(named: loveIconName), for: .normal)
    }
    
    func customUI() {
        itemName.setBottomBorder(color: APP_COLOR)
    }
    
    
}

