//
//  FeebackController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/21/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class FeebackController: UIViewController {

    @IBOutlet weak var product: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var content: UITextView!
    
    var user = UserResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
    }
    
    func checkInput() {
        guard let content = content.text else {
            
            return
        }
        
//        guard   else {
//            <#statements#>
//        }
    }

    func setupView() {
        name.text = user.name
        phone.text = user.phone
        email.text = user.email
    }

}
