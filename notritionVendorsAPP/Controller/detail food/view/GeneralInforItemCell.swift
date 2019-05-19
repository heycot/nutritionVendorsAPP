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
        
        showLoveStatus(itemID: item.id ?? "")
        itemImage.loadImageFromFirebase(folder: ReferenceImage.shopItem.rawValue + "\(item.id ?? "")/\(item.avatar ?? "")")
        itemComments.text = "\(item.comment_number ?? 0)"
        itemFavorites.text = "\(item.favorites_number ?? 0)"
        
        itemName.text      = item.name ?? ""
        itemComments.text  = String(item.comment_number ?? 0)
        itemPhotos.setTitle( "\(item.images?.count ?? 0)" ,for: .normal)
        itemFavorites.text = String(item.favorites_number ?? 0)
        itemRating.text    = String(format: "%.2f", item.rating ?? 0)
    }
    
    func showLoveStatus(itemID: String) {
        FavoritesService.shared.checkLoveStatus(shopItemID: itemID) { (data) in
            guard let data = data else { return }
            
            if !data {
                self.loveBtn.imageView!.image = UIImage(named: "unlove")
            }
            self.loveBtn.imageView!.image = UIImage(named: "loved")
        }
    }
    
    
    func customUI() {
        itemName.setBottomBorder(color: APP_COLOR)
    }
    
}

