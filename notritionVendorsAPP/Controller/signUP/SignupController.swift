//
//  SignupController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Photos

class SignupController: UIViewController {

    // Outlets
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    // variables
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User()
        setUpUI()
    }
    
    func setUpUI() {
        spinner.isHidden = true
        avatarImage.setRounded(color: .white)
        userNameTxt.setBottomBorder(color: appColor)
        phoneTxt.setBottomBorder(color: appColor)
        emailTxt.setBottomBorder(color: appColor)
        passTxt.setBottomBorder(color: appColor)
        confirmPassTxt.setBottomBorder(color: appColor)
    }
    
    @IBAction func cacelPressed(_ sender: Any) {
    }
    
    @IBAction func donePressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
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
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func generateNameForImage() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "IMG_hh.mm.ss.dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    @objc func dismisHandle() {
        dismiss(animated: true, completion: nil)
    }
}

extension SignupController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        var fileName = ""
        
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            if let firstAsset = assets.firstObject,
                let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                fileName = firstResource.originalFilename
            } else {
                fileName = generateNameForImage()
            }
        } else {
            fileName = generateNameForImage()
        }
        
        if (fileName != "") {
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
            print(paths)
            let imageData = selectedImage.jpegData(compressionQuality: 0.75)
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            
            user?.avatar = fileName
            self.dismisHandle()
            self.avatarImage.image = UIImage(named: fileName)
        }
        self.dismisHandle()
    }
}
