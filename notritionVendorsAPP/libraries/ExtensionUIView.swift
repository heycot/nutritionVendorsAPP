//
//  ExtensionUIView.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

extension UIView {
    func setButtomBorderRadious() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
}
