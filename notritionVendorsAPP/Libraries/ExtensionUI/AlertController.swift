//
//  AlertController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/6/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit


class AlertController {
    static let shared = AlertController()
    
    func showAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: Notification.email.title.rawValue, message: Notification.email.detail.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        return alert
    }
}
