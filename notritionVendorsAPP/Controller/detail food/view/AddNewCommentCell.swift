//
//  AddNewCommentCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints
import IQKeyboardManagerSwift

class AddNewCommentCell: UITableViewCell {

    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var content: UITextView!
    
    var shopitemId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpUI()
        handlerkeyboard()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func saveItemId(id: Int ) {
        shopitemId = id
    }
    
    func setUpUI() {
        title.delegate = self
        content.delegate = self
        
        rating.settings.fillMode = .precise
        title.setBottomBorder(color: .lightGray)
//        content.setBorder(with: .lightGray)
        
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
            comment.title = title.text!
            comment.rating = rating.rating
            comment.user_id = 0
            comment.shopItem_id = shopitemId
            comment.status = 1
            comment.create_date = Date()
            
            CommentServices.shared.addNewComment(comment: comment) { (data) in
                guard let data = data else { return }
                
                if data.id != nil {
                    
                } else {
                    
                }
            }
        }
    }
    
    func validateInput() -> Bool {
        
        if title.text == "" || content.text == "" {
            showAlertError(title: "Error", message: "All the information are required!")
            return false
        } else if !title.text!.isValidString() {
            showAlertError(title: "Error", message: "The title has only letters, underscores and numbers allowed!")
            return false
            
        } else if !content.text!.isValidString() {
            showAlertError(title: "Error", message: "The content has only letters, underscores and numbers allowed!")
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

extension AddNewCommentCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        textField.keyboardToolbar.doneBarButton.invocation = invocation
    }
}


extension AddNewCommentCell: UITextViewDelegate {
    
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

