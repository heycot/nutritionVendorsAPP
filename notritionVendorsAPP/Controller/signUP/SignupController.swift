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
    
    
    // variables
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User()
        setUpUI()
    }
    
    func setUpUI() {
        avatarImage.setRounded(color: .white)
        userNameTxt.setBottomBorder(color: appColor)
        phoneTxt.setBottomBorder(color: appColor)
        emailTxt.setBottomBorder(color: appColor)
        passTxt.setBottomBorder(color: appColor)
        confirmPassTxt.setBottomBorder(color: appColor)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if checkInputData() {
            AuthServices.instance.registerUser(user: self.user!) { (success) in
                if success {
                    AuthServices.instance.loginUser(email: self.user!.email, password: self.user!.password, completion: { (success) in
                        
                        if success {
                            print("logined user " )
                        }
                    })
                }
            }
        }
        
    }
    
    func checkInputData() -> Bool {
        guard let username = userNameTxt.text, userNameTxt.text != "", userNameTxt.text!.isValidUserName() else{
            return false
        }
        
        guard let phone = phoneTxt.text, phoneTxt.text != "", phoneTxt.text!.isValidPhone() else {
            return false
        }
        
        guard let email = emailTxt.text , emailTxt.text != "", emailTxt.text!.isValidEmail() else {
            return false
        }
        
        guard let password = passTxt.text, passTxt.text != "" , passTxt.text!.isValidPassword() else {
            return false
        }
        
        guard let _ = confirmPassTxt.text, confirmPassTxt.text != "", confirmPassTxt.text!.isValidPassword(), confirmPassTxt.text == password else {
            return false
        }
        
        self.user = User(id: 0, username: username, email: email, phone: phone, password: password, birthday: Date(), avatar: "", address: "", create_date: Date(), status: 1)
        return true
    }
    
    @IBAction func chooseAvatarpressed(_ sender: Any) {
    }
}
