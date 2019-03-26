//
//  GeneralInforItemCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit



class GeneralInforItemCell: UITableViewCell {

    @IBOutlet weak var imageICarousel: UIView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemComments: UITextField!
    @IBOutlet weak var itemPhotos: UITextField!
    @IBOutlet weak var itemFavorites: UITextField!
    @IBOutlet weak var itemRating: UITextField!
    
    var item = ShopItemResponse()
    var imgArr = [CustomImageView]()
    
    func updateView(item: ShopItemResponse) {
        customUI()
        setupData(item: item)
        
        itemName.text      = item.name ?? ""
        itemComments.text  = String((item.comments?.count) ?? 0)
        itemPhotos.text    = String((item.documents?.count) ?? 0)
        itemFavorites.text = String(item.favorites_number ?? 0)
        itemRating.text    = String(format: "%.2f", item.rating ?? 0)
        
    }
    
    
    func customUI() {
        setupImageICarousel()
        itemName.setBottomBorder(color: APP_COLOR)
    }
    
    func setupData(item: ShopItemResponse) {
        
        self.item = item
        for doc in item.documents! {
            let image = CustomImageView()
            image.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + doc.link! + ".jpg")
            imgArr.append(image)
        }
    }
    
    
    func setupImageICarousel() {
        let carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 200))
        carousel.dataSource = self
        carousel.delegate = self
        carousel.type = .coverFlow
        carousel.isPagingEnabled = true
        imageICarousel.addSubview(carousel)
        
    }
}

extension GeneralInforItemCell : iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return imgArr.count
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {

        var imageView: CustomImageView!
        if view == nil {
            imageView = CustomImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 200))
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView = view as? CustomImageView
        }

        imageView = imgArr[index]
        return imageView 
    }
}

