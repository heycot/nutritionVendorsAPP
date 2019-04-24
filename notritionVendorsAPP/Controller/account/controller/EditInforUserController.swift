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
            let dateStr = NSObject().convertToString(date: user.birthday! , dateformat: DateFormatType.date)
            birthdayTxt.text = dateStr
        } else {
            birthdayTxt.text = ""
        }
    }
    

    @IBAction func doneBtnPressed(_ sender: Any) {
        guard let nameStr = nameTxt.text, (nameTxt.text?.isValidUserName())! else {
            notification.text = Notification.username.title.rawValue
            detailNotification.text = Notification.username.detail.rawValue
            notification.isHidden = false
            detailNotification.isHidden = false
            return
        }
        
        let userEdit = User()
        userEdit.id = user.id
        userEdit.name = nameStr
        userEdit.phone = phoneTxt.text
        userEdit.birthday = convertToDate(dateString: birthdayTxt.text!)
        userEdit.address = addressTxt.text
        
        AuthServices.instance.editInfor(user: userEdit) { (data) in
            guard let data = data else { return }
            
            self.user = data
            self.viewInfor()
            self.reloadInputViews()
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
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
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
