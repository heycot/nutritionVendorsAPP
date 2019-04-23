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
    
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notification.isHidden = true
        currentPass.delegate = self
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if validInput() {
            AuthServices.instance.changePassword(pass: self.password) { (data) in
                guard let data = data else { return }
                
                if data == 1 {
                    self.notification.text = "Change password successfully!"
                    self.notification.isHidden = false
//                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.notification.text = "Something went wrong. Please try again."
                    self.notification.isHidden = false
                }
            }
        }
    }
    
    func disableInputText() {
        newPass.isUserInteractionEnabled = false
        confirmPass.isUserInteractionEnabled = false
    }
    
    func enableInputText() {
        newPass.isUserInteractionEnabled = true
        confirmPass.isUserInteractionEnabled = true
    }
    
    
    func validInput() -> Bool {
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

extension ChangePasswordController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        guard let password = currentPass.text, currentPass.text!.isValidPassword() else {
//            notification.text = Notification.password.detail.rawValue
//            disableInputText()
//            return
//        }
        
        guard let password = currentPass.text else {
            notification.text = Notification.password.detail.rawValue
            disableInputText()
            return
        }
        
        AuthServices.instance.checkPassword(pass: password) { (data) in
            guard let data = data else { return }
            
            if data == 0 {
                self.disableInputText()
                self.notification.text = "Your current password is not correct."
                self.notification.isHidden = false
            }
        }
        
        self.password = password
        
         enableInputText()
    }
}
