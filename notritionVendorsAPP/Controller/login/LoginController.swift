//
//  ViewController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/25/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

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
            let alert = UIAlertController(title: "Invalid email syntax!", message: "Please enter a valid email address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
//        } else if !(passwordTF.text?.isValidPassword())! {
//            let alert = UIAlertController(title: "Invalid password syntax!", message: "Password should have at least 8 letters, 1 number and 1 special letter", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//            self.present(alert, animated: true)
//
//
        } else {
            
            AuthServices.instance.loginUser(email: emailTF.text!, password: passwordTF.text!) { (user) in
                guard let user = user else {
                    return
                    
                }
                
                if user.id == nil {
                    let alert = UIAlertController(title: "Can not log in!", message: "Your email and password do not match any account.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    
                    //set up is logined
                    AuthServices.instance.isLoggedIn = true
                    AuthServices.instance.authToken = user.token!
                    AuthServices.instance.userEmail = user.email!
                    
                    //to save list favorites of user
                    FavoritesService.shared.getAllByUser() { (data) in
                        guard let data = data else { return   }
                        
                        FavoritesService.shared.favorites = data
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
            
        }
        
    }
}

