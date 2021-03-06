//
//  ViewController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/25/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import PKHUD

class LoginController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        emailTF.setBottomBorder(color: APP_COLOR)
        passwordTF.setBottomBorder(color: APP_COLOR)
    }

    // handle click login button
    @IBAction func loginPressed(_ sender: Any) {
        
        
        if !(emailTF.text?.isValidEmail())! {
            let alert = UIAlertController(title: NSLocalizedString(Notification.email.title.rawValue, comment: "") , message: NSLocalizedString(Notification.email.detail.rawValue, comment: "") , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "") , style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "") , style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        } else if !(passwordTF.text?.isValidPassword())! {
            let alert = UIAlertController(title: NSLocalizedString(Notification.password.title.rawValue, comment: "") , message: NSLocalizedString(Notification.password.detail.rawValue, comment: "") , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)


        } else {
            HUD.show(.progress)
            
            AuthServices.instance.signin(email: emailTF.text!, password: passwordTF.text!) { (data) in
                guard let data = data else { return }
                
                
                HUD.hide()
                if !data {
                    let alert = UIAlertController(title: NSLocalizedString("Can not log in!", comment: "") , message: NSLocalizedString("Your email and password do not match any account", comment: "") , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "") , style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "") , style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        
    }
}

