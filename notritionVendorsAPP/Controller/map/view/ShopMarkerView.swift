//
//  ShopMarkerView.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/18/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ShopMarkerView: NibDesignable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
    }
    
    func config(shop: ShopResponse) {
    }
}
