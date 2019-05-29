//
//  ChangePasswordController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController {
    
    
    @IBOutlet weak var titleNotification: UILabel!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var currentPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
//    var password = ""
    var newPassword = ""
    
    var isCurrentCorrect =  false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notification.isHidden = true
        titleNotification.isHidden = true
        currentPass.delegate = self
        newPass.delegate = self
        confirmPass.delegate = self
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if validInput() && isCurrentCorrect {
//            AuthServices.instance.changePassword(pass: self.newPassword) { (data) in
//                guard let data = data else { return }
//
//                if data == 1 {
//                    self.titleNotification.text = "Change password successfully!"
//                    self.notification.isHidden = true
//                    self.titleNotification.isHidden = false
//                    self.clearInput()
////                    self.navigationController?.popViewController(animated: true)
//                } else {
//                    self.titleNotification.text = "Something went wrong. Please try again."
//                    self.titleNotification.isHidden = false
//                    self.notification.isHidden = true
//                }
//            }
        }
    }
    
    func clearInput() {
        currentPass.text = ""
        newPass.text = ""
        confirmPass.text = ""
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
        
        if !checkValidNewPass() || !checkValidConfirmPass() {
            return false
        }
        return true
    }
    
    func checkValidNewPass() -> Bool {
        guard let pass = newPass.text, newPass.text!.isValidPassword() else {
            titleNotification.text = NSLocalizedString(Notification.password.title.rawValue, comment: "")
            notification.text = NSLocalizedString(Notification.password.detail.rawValue, comment: "")
            notification.isHidden = false
            titleNotification.isHidden = false
            return false
        }
        
        newPassword = pass
        return true
    }
    
    func checkValidConfirmPass() -> Bool {
        guard  let _ = confirmPass.text, confirmPass.text!.isValidPassword(), confirmPass.text! == newPassword else {
            titleNotification.text = NSLocalizedString(Notification.confirmPass.title.rawValue, comment: "")
            notification.text = NSLocalizedString(Notification.confirmPass.detail.rawValue, comment: "")
            notification.isHidden = false
            titleNotification.isHidden = false
            return false
        }
        
        return true
    }
}

extension ChangePasswordController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let password = currentPass.text, currentPass.text!.isValidPassword() else {
            notification.text = NSLocalizedString(Notification.password.detail.rawValue, comment: "") 
            disableInputText()
            return
        }
        
        switch textField {
            case currentPass:
                guard let password = currentPass.text else {
                    notification.text = NSLocalizedString(Notification.password.detail.rawValue, comment: "")
                    disableInputText()
                    self.isCurrentCorrect = false
                    return
                }
                
//                AuthServices.instance.checkPassword(pass: password) { (data) in
//                    guard let data = data else { return }
//                    
//                    if data == 0 {
//                        self.isCurrentCorrect = false
//                        self.titleNotification.text = "Your current password is not correct."
//                        self.titleNotification.isHidden = false
//                        self.notification.isHidden = true
//                        
//                    } else {
//                        self.isCurrentCorrect = true
//                        self.titleNotification.isHidden = true
//                        self.notification.isHidden = true
//                    }
//                    
//                }
                
//                self.password = password
            case newPass:
                if !checkValidNewPass() {
                    //
                }
            default:
                if !checkValidConfirmPass() {
                    //
                }
        }
    }
}
