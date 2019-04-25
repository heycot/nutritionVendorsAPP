//
//  CategoryCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var icon : CustomImageView!
    @IBOutlet weak var nameCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView(Category: CategoryResponse) {
        icon.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + Category.icon!)
        nameCategory.text = Category.name!
        
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = true;
    }

}
