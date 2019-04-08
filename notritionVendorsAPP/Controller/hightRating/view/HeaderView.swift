//
//  HeaderView.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class HeaderView: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView(titleStr: String) {
        title.text = titleStr
    }

}
