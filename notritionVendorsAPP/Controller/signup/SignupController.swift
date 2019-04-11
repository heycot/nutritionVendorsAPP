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
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var confirmPassTXT: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var notification : UILabel!
    @IBOutlet weak var detailNotifi : UILabel!
    
    // variables
    var user: User?
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User()
        user?.avatar = "logo"
        setUpUI()
    }
    
    func setUpUI() {
        spinner.isHidden = true
        avatarImage.setRounded(color: .white)
        nameTxt.setBottomBorder(color: APP_COLOR)
        emailTxt.setBottomBorder(color: APP_COLOR)
        passTxt.setBottomBorder(color: APP_COLOR)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if checkInputData() {
            
            notification.text = ""
            detailNotifi.text = ""
            
            spinner.isHidden = false
            spinner.startAnimating()
            
            if image == nil {
                image = UIImage(named: (user?.avatar!)!)
            }
            
            AuthServices.instance.registerUser(user: self.user!, image: image!) { (data) in
                guard let user = data else { return }
                
                if user.id != nil {
                    AuthServices.instance.loginUser(email: self.emailTxt.text!, password: self.passTxt.text!, completion: { (data) in
                        guard let data = data else { return }
                        
                        AuthServices.instance.saveUserLogedIn(user: data)
                        self.spinner.stopAnimating()
                        self.backTwoViewController()
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
        
        self.user?.name = name
        self.user?.email = email
        self.user?.password = password
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
        formatter.dateFormat = "AVATAR_hh.mm.ss.dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    @objc func dismisHandle() {
        dismiss(animated: true, completion: nil)
    }
    
    func getImageFormatFromUrl(url : URL) -> String {
        
        if url.absoluteString.hasSuffix("JPG") {
            return"JPG"
        }
        else if url.absoluteString.hasSuffix("PNG") {
            return "PNG"
        }
        else if url.absoluteString.hasSuffix("GIF") {
            return "GIF"
        }
        else {
            return "jpg"
        }
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

extension SignupController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        var fileName = ""
        
        if let url = info[UIImagePickerController.InfoKey.phAsset] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            // get for mat of image
            let imageFormat = getImageFormatFromUrl(url: url)
            
            if let firstAsset = assets.firstObject,
                let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                fileName = firstResource.originalFilename
            } else {
                fileName = generateNameForImage() + "." + imageFormat
            }
        } else {
            fileName = generateNameForImage() + ".jpg"
        }
        
        if (fileName != "") {
//            let fileManager = FileManager.default
//            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
//            print(paths)
//            let imageData = selectedImage.jpegData(compressionQuality: 0.75)
//            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            
            user?.avatar = fileName
            self.image = selectedImage
            self.dismisHandle()
            self.avatarImage.image = selectedImage
        }
        self.dismisHandle()
    }
}
