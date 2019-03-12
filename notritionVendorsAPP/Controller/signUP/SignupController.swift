//
//  SignupController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class SignupController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
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
    
}