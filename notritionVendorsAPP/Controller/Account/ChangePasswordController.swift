//
//  ChangePasswordController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        saveBtn.setBorderRadous(color: UIColor.white)
        cancelBtn.setBorderRadous(color: UIColor.white)
    }
    
    @IBAction func clickSave(_ sender: Any) {
        dismissHandle()
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        dismissHandle()
    }
    
    func dismissHandle() {
        dismiss(animated: true, completion: nil)
    }
}
