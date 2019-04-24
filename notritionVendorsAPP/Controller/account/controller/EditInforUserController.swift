//
//  EditInforUserController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/24/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class EditInforUserController: UIViewController {
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var birthdayTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    
    var user =  UserResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
    
        notification.isHidden = true
        emailTxt.text = user.email!
        nameTxt.text = user.name!
        phoneTxt.text = user.phone!
        addressTxt.text = user.address!
        
        if user.birthday != nil {
            let dateStr = NSObject().convertToString(date: user.birthday! , dateformat: DateFormatType.date)
            birthdayTxt.text = dateStr
        } else {
            birthdayTxt.text = ""
        }
    }
    

    @IBAction func doneBtnPressed(_ sender: Any) {
        
    }
    
}
