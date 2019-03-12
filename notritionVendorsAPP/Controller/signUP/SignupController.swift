//
//  SignupController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class SignupController: UIViewController {

    // Outlets
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        username.setBottomBorder(color: UIColor.lightGray)
        phone.setBottomBorder(color: UIColor.lightGray)
        address.setBottomBorder(color: UIColor.lightGray)
        password.setBottomBorder(color: UIColor.lightGray)
        confirmPassword.setBottomBorder(color: UIColor.lightGray)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        var user = User()
        
        guard user.username = userNameTxt.text, userNameTxt.text != "", userNameTxt.text.isValidUserName() else {
            return
        }
        
        guard user.phone = phoneTxt.text, phoneTxt.text != "", phoneTxt.text?.isValidPhone() else {
            return
        }
        
        guard user.email = emailTxt.text , emailTxt.text != "", emailTxt.text?.isValidEmail() else {
            return
        }
        
        guard user.password = passTxt.text, passTxt.text != "" , passTxt.text?.isValidPassword() else {
            return
        }
        
        guard user.password = confirmPassTxt.text, confirmPassTxt.text != "", confirmPassTxt.text?.isValidPassword(), confirmPassTxt.text == password else {
            return
        }
        
        
        AuthServices.instance().registerUser(user: user) { (success) in
            if success {
                AuthServices.instance.loginUser(email: user.email, password: user.password, completion: { (success) in
                    
                    if success {
                        print("logined user " )
                    }
                })
            }
        }
    }
    
    @IBAction func chooseAvatarpressed(_ sender: Any) {
    }
}
