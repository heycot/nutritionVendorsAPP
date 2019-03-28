//
//  ExtentionDouble.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
