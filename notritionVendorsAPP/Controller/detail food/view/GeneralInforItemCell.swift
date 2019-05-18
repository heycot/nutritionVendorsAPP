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
    @IBOutlet weak var itemComments: CustomTextFeild!
    @IBOutlet weak var itemPhotos: UIButton!
    @IBOutlet weak var itemFavorites: CustomTextFeild!
    @IBOutlet weak var itemRating: CustomTextFeildRating!
    @IBOutlet weak var loveBtn: CustomButton!
    
    
    func updateView(item: ShopItemResponse) {
        customUI()
        
        let urlStr = BASE_URL + FavoritesAPI.checkStatus.rawValue + "/" + (item.id ?? "")
        let urlComment = BASE_URL + CommentAPI.countByShopItem.rawValue + "/" + String(item.id ?? "")
        let urlRating = BASE_URL + ShopItemAPI.getRating.rawValue + "/" + String(item.id ?? "")
        let urlFavorites = BASE_URL + FavoritesAPI.countByShopItem.rawValue + "/" + String(item.id ?? "")
        
        loveBtn.viewImageUsingUrlString(urlString: urlStr)
        itemImage.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + (item.avatar ?? "logo.jpg"))
        itemComments.count(urlString: urlComment)
        itemFavorites.count(urlString: urlFavorites)
        itemRating.getRating(urlString: urlRating)
        
        itemName.text      = item.name ?? ""
//        itemComments.text  = String(item.comment_number ?? 0)
        itemPhotos.setTitle(0,for: .normal)
//        itemFavorites.text = String(item.favorites_number ?? 0)
//        itemRating.text    = String(format: "%.2f", item.rating ?? 0)
    }
    
    
    func customUI() {
        itemName.setBottomBorder(color: APP_COLOR)
    }
    
    
}

