//
//  GeneralInforItemCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit


class GeneralInforItemCell: UITableViewCell {

    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemComments: UITextField!
    @IBOutlet weak var itemPhotos: UITextField!
    @IBOutlet weak var itemFavorites: UITextField!
    @IBOutlet weak var itemRating: UITextField!
    
    var item = ShopItemResponse()
    
    func updateView(item: ShopItemResponse) {
//        let urlStr = BASE_URL_IMAGE + item.avatar! + ".jpg"
//
//        itemImage.loadImageUsingUrlString(urlString: urlStr)
////        setupItemImage(urlStr: urlStr)
        self.item = item
        
        itemName.text      = item.name ?? ""
        itemComments.text  = String((item.comments?.count) ?? 0)
        itemPhotos.text    = String((item.documents?.count) ?? 0)
        itemFavorites.text = String(item.favorites_number ?? 0)
        itemRating.text    = String(format: "%.2f", item.rating ?? 0)
        
        customUI()
    }
    
    func customUI() {
        itemName.setBottomBorder(color: APP_COLOR)
    }
    
    
    func setupItemImage() {
        
    }
}

//
//extension GeneralInforItemCell: iCarouselDelegate, iCarouselDataSource {
//    func numberOfItems(in carousel: iCarousel) -> Int {
//        return imgArr.count
//    }
//
//    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//
//        var imageView: UIImageView!
//        if view == nil {
//            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 300))
//            imageView.contentMode = .scaleAspectFit
//        } else {
//            imageView = view as? UIImageView
//        }
//
////        imageView.image = item.documents[index]
//        return imageView
//    }
//}
