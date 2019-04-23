//
//  ChangePasswordController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController {
    
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var currentPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notification.isHidden = true
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if validInput() {
            
        }
    }
    
    func validInput() -> Bool {
        guard let password = currentPass.text, currentPass.text!.isValidPassword() else {
            notification.text = Notification.password.detail.rawValue
//            detailNotifi.text = Notification.password.detail.rawValue
            return false
        }
        
        guard let pass = newPass.text, newPass.text!.isValidPassword() else {
            notification.text = Notification.password.detail.rawValue
//            detailNotifi.text = Notification.password.detail.rawValue
            return false
        }
        
        guard  let _ = confirmPass.text, confirmPass.text!.isValidPassword(), confirmPass.text! == pass else {
            notification.text = Notification.confirmPass.detail.rawValue
//            detailNotifi.text = Notification.confirmPass.detail.rawValue
            return false
        }
        
        return true
    }
}
