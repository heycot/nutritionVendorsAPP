//
//  NewCommentController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/15/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos
import IQKeyboardManagerSwift

class NewCommentController: UIViewController {
    @IBOutlet weak var shopItemName: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var ratingview: CosmosView!
    @IBOutlet weak var titleCmt: UITextField!
    @IBOutlet weak var content: UITextView!
    
    var shopitemId = 0
    var nameShop = ""
    var addressShop = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        
        self.title = "Write review"
        shopItemName.text = nameShop
        address.text = addressShop

        setUpUI()
        handlerkeyboard()
    }
    
    @objc func donePressed() {
        didPressOnDoneButton()
    }
    
    func setUpUI() {
        
        ratingview.rating = 0.0
        ratingview.settings.updateOnTouch = true
        ratingview.settings.fillMode = .precise
        ratingview.text = "Rate me"
        
        titleCmt.delegate = self
        content.delegate = self
        
        address.setBottomBorder(color: APP_COLOR)
        ratingview.setBottomBorder(color: .darkGray)
        titleCmt.setBottomBorder(color: .darkGray)
        
    }
    
    
    // handle keyboard when add new comment
    func handlerkeyboard() {
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Send"
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.shouldPlayInputClicks = false // set to true by default
    }
    
    
    @objc func didPressOnDoneButton() {
        if validateInput() {
            let comment = Comment()
            
            comment.id = 0
            comment.content = content.text
            comment.title = titleCmt.text!
            comment.rating = ratingview.rating
            comment.user_id = 0
            comment.shopItem_id = shopitemId
            comment.status = 1
            comment.create_date = Date()
            
            CommentServices.shared.addNewComment(comment: comment) { (data) in
                guard let data = data else { return }
                
                if data.id != nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: Notification.comment.addCmtFailedTitle.rawValue, message: Notification.comment.addCmtFailedMessgae.rawValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func validateInput() -> Bool {
        
        if titleCmt.text == "" || content.text == "" {
            showAlertError(title: "Error", message: Notification.comment.nilWithInfor.rawValue)
            return false
        } else if !titleCmt.text!.isValidString() {
            showAlertError(title: "Error", message: Notification.comment.titleNotValid.rawValue)
            return false
            
        } else if !content.text!.isValidString() {
            showAlertError(title: "Error", message: Notification.comment.contentNotValid.rawValue)
            return false
            
        } else {
            return true
        }
    }
    
    func showAlertError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        alert.present(alert, animated: true, completion: nil)
    }
    
}

extension NewCommentController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        textField.keyboardToolbar.doneBarButton.invocation = invocation
    }
}


extension NewCommentController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = "Enter content"
            textView.textColor = .lightGray
        } else {
            textView.text = ""
            textView.textColor = .black
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        textView.keyboardToolbar.doneBarButton.invocation = invocation
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.textColor == UIColor.lightGray) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    
}
