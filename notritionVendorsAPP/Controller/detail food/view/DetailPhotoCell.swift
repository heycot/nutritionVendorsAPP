//
//  DetailPhotoCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/1/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class DetailPhotoCell: UICollectionViewCell {
    @IBOutlet weak var image: CustomImageView!
    
    func updateView(image: CustomImageView) {
        self.image.loadImageUsingUrlString(urlString: image.imageUrlString! )
    }
    
}
