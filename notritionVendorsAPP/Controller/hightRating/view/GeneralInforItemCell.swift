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
    @IBOutlet weak var itemPhotos: UITextField!
    @IBOutlet weak var itemFavorites: UITextField!
    @IBOutlet weak var itemRating: UITextField!
    
    var item = ShopItemResponse()
    var imgArr = [CustomImageView]()
    
    func updateView(item: ShopItemResponse) {
        customUI()
        showImage(name: item.avatar!)
        
        itemName.text      = item.name ?? ""
        itemComments.text  = String((item.comments?.count) ?? 0)
        itemPhotos.text    = String((item.documents?.count) ?? 0)
        itemFavorites.text = String(item.favorites_number ?? 0)
        itemRating.text    = String(format: "%.2f", item.rating ?? 0)
        
    }
    
    
    func customUI() {
        itemName.setBottomBorder(color: APP_COLOR)
    }
    
    func showImage(name: String) {
        itemImage.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + name  + ".jpg")
    }
    
    
}


