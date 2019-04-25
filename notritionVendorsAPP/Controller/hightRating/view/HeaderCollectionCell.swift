//
//  HeaderCollectionCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class HeaderCollectionCell: UICollectionReusableView {
        
    @IBOutlet weak var title: UILabel!
    
    func updateView(titleStr: String) {
        title.text =  " " + titleStr
//        title.backgroundColor = HEADER_COLOR
//        title.setBottomBorder(color: APP_COLOR)
    }
}
