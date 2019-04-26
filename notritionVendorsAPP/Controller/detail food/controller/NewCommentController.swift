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
    var isNew = true
    var lastComment = CommentResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        
        shopItemName.text = nameShop
        address.text = addressShop

        setUpUI()
        handlerkeyboard()
        getReviewOfUser()
    }
    
    @objc func donePressed() {
        didPressOnDoneButton()
    }
    
    func getReviewOfUser() {
        CommentServices.shared.getReviewOfUser(shopitemId: shopitemId) { data in
            if data != nil || data!.id != nil {
                self.isNew = false
                self.title = "Edit review"
                self.lastComment = data!
                self.viewLastComment(comment: data!)
            } else {
                self.title = "Write review"
            }
        }
    }

    func viewLastComment(comment: CommentResponse) {
        
        ratingview.rating = comment.rating ?? 3.0
        titleCmt.text = comment.title ?? ""
        content.text = comment.content ?? ""
        content.textColor = .black
    }
    
    func setUpUI() {
        
        if isNew {
            content.text = "Enter content"
            content.textColor = .lightGray
        }
        
        
        ratingview.rating = 3.0
        ratingview.settings.minTouchRating = 1.0
        ratingview.settings.updateOnTouch = true
        ratingview.settings.fillMode = .precise
        ratingview.text = "Rate me"
        
        titleCmt.delegate = self
        content.delegate = self
        
        address.setBottomBorder(color: APP_COLOR)
        content.setBorder(with: BORDER_TEXT_COLOR)
        content.setBorderRadious(radious: 10)
//        ratingview.setBottomBorder(color: .darkGray)
//        titleCmt.setBottomBorder(color: .darkGray)
        
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
            
            comment.content = content.text
            comment.title = titleCmt.text!
            comment.rating = ratingview.rating
            comment.user_id = 0
            comment.shopItem_id = shopitemId
            comment.status = 1
            comment.create_date = Date()
            
            if isNew {
                comment.id = 0
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
            } else {
                comment.id = self.lastComment.id!
                CommentServices.shared.editComment(comment: comment) { (data) in
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
    }
    
    func validateInput() -> Bool {
        
        if titleCmt.text == "" || titleCmt.text?.lowercased() == "enter title" || content.text == "" || content.text.lowercased() == "enter content" {
            showAlertError(title: "Error", message: Notification.comment.nilWithInfor.rawValue)
            return false
        } else if !titleCmt.text!.isValidString() {
            showAlertError(title: "Error", message: Notification.comment.titleNotValid.rawValue)
            return false
            
        } else if content.text == nil || !content.text!.isValidString() {
            showAlertError(title: "Error", message: Notification.comment.contentNotValid.rawValue)
            return false
            
        } else {
            return true
        }
    }
    
    func showAlertError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension NewCommentController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        textField.keyboardToolbar.doneBarButton.invocation = invocation
    }
}


extension NewCommentController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print("textViewDidChangeSelection")
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isNew {
            if textView.text.isEmpty {
                textView.text = "Enter content"
                textView.textColor = .lightGray
            } else {
                textView.text = ""
                textView.textColor = .black
            }
        }
        
        textView.selectedRange = NSMakeRange(0, 0);
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.selectedRange = NSMakeRange(0, 0);
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        textView.keyboardToolbar.doneBarButton.invocation = invocation
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.textColor == UIColor.lightGray) {
            
            if isNew {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
    }
    
    
}
