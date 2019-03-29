//
//  PhotoItemCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class PhotoItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: CustomImageView!
    
    func updateView(image: String) {
        imageView.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + image + ".jpg")
    }
    
}
