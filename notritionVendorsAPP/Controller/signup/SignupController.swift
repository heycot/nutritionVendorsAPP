//
//  SignupController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Photos
import YPImagePicker
import PKHUD

class SignupController: UIViewController {

    // Outlets
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var confirmPassTXT: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var notification : UILabel!
    @IBOutlet weak var detailNotifi : UILabel!
    
    // variables
    var user = User()
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.avatar = "logo"
        setUpUI()
    }
    
    func setUpUI() {
        spinner.isHidden = true
        avatarImage.setRounded(color: .white)
        nameTxt.setBottomBorder(color: APP_COLOR)
        emailTxt.setBottomBorder(color: APP_COLOR)
        passTxt.setBottomBorder(color: APP_COLOR)
        confirmPassTXT.setBottomBorder(color: APP_COLOR)
        
        passTxt.delegate = self
        confirmPassTXT.delegate = self
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if checkInputData() {
            
            notification.text = ""
            detailNotifi.text = ""
            
            HUD.flash(.success, delay: 1.0)
            
            AuthServices.instance.signup(name: user.name ?? "", email: user.email ?? "", password: user.password ?? "") { (data) in
                guard let data = data else { return }
                
                if !data {
                    self.notification.text = "Signup failed"
                    self.detailNotifi.text = "Something went wrong. Please try again"
                } else {
                    AuthServices.instance.signin(email: self.user.email, password: self.user.password, completion: { (data) in
                        guard let data = data else { return }
                        
                        if data {
                            if self.image == nil {
                                self.image = UIImage(named: self.user.avatar!)
                            }
                            let folder = "user_images/\(self.user.avatar!)"
                            ImageServices.instance.uploadMedia(image: self.image!, reference: folder, completion: { (data) in
                                if data == nil { return }
                            })
                            self.backTwoViewController()
                        }
                    })
                }
            }
            
        }
        
    }
    
    func backTwoViewController() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func checkInputData() -> Bool {
        guard let name = nameTxt.text, nameTxt.text!.isValidUserName() else{
            notification.text = Notification.username.title.rawValue
            detailNotifi.text = Notification.username.detail.rawValue
            return false
        }
        
        guard let email = emailTxt.text , emailTxt.text!.isValidEmail() else {
            notification.text = Notification.email.title.rawValue
            detailNotifi.text = Notification.email.detail.rawValue
            return false
        }
        
        guard let password = passTxt.text, passTxt.text!.isValidPassword() else {
            notification.text = Notification.password.title.rawValue
            detailNotifi.text = Notification.password.detail.rawValue
            return false
        }
        
        guard  let _ = confirmPassTXT.text, confirmPassTXT.text!.isValidPassword(), confirmPassTXT.text! == password else {
            notification.text = Notification.confirmPass.title.rawValue
            detailNotifi.text = Notification.confirmPass.detail.rawValue
            return false
        }
        
        self.user.name = name
        self.user.email = email
        self.user.password = password
        return true
    }
    
    @IBAction func chooseAvatarpressed(_ sender: Any) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                
                self.user.avatar = String.generateNameForImage()
                self.image = photo.image
                self.avatarImage.image = photo.image
                self.avatarImage.setRounded(color: .white)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
   
    @objc func dismisHandle() {
        dismiss(animated: true, completion: nil)
    }
   
}

extension SignupController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin edit text")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("edit text")
        return true
    }
    
}

