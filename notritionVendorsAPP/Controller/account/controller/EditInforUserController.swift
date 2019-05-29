//
//  EditInforUserController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/24/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import PKHUD

class EditInforUserController: UIViewController {
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var detailNotification: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var birthdayTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    
    var user =  UserResponse()
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        phoneTxt.keyboardType = UIKeyboardType.numberPad
        viewInfor()
        showDatePicker()
    }
    
    func viewInfor() {
    
        notification.isHidden = true
        detailNotification.isHidden = true
        
        emailTxt.text = user.email!
        nameTxt.text = user.name!
        phoneTxt.text = user.phone!
        addressTxt.text = user.address!
        
        if user.birthday != nil {
            let dateStr = NSObject().convertToString(date: user.birthdayDate! , dateformat: DateFormatType.date)
            birthdayTxt.text = dateStr
        } else {
            birthdayTxt.text = ""
        }
    }
    

    @IBAction func doneBtnPressed(_ sender: Any) {
        guard let nameStr = nameTxt.text, (nameTxt.text?.isValidUserName())! else {
            notification.text = NSLocalizedString(Notification.username.title.rawValue, comment: "")
            detailNotification.text = NSLocalizedString(Notification.username.detail.rawValue, comment: "") 
            notification.isHidden = false
            detailNotification.isHidden = false
            return
        }
        
        user.name = nameStr
        user.phone = phoneTxt.text
        user.birthday = convertToDate(dateString: birthdayTxt.text!).timeIntervalSince1970
        user.address = addressTxt.text
        
        HUD.show(.progress)
        
        AuthServices.instance.edit(user: user) { (data) in
            guard let data = data else { return }
            
            HUD.hide()
            if !data {
                
                self.notification.text = NSLocalizedString("Something went wrong. Please try again", comment: "") 
                self.notification.isHidden = false
                
            } else {
                self.notification.text = NSLocalizedString("Update successful", comment: "")
                self.notification.isHidden = false
//                self.viewInfor()
//                self.reloadInputViews()
            }
        }
        
    }
    
}


// handle datepicker
extension EditInforUserController {
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = -10
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        birthdayTxt.inputAccessoryView = toolbar
        birthdayTxt.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthdayTxt.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
