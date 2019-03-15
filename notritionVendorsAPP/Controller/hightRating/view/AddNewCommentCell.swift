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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpUI()
        handlerkeyboard()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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
    
    func addNewComment() {
        
    }
    
    
}



extension AddNewCommentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter description"
            textView.textColor = UIColor.lightGray
            textView.layer.backgroundColor = UIColor.lightGray.cgColor
            textView.layer.borderColor = UIColor(red: CGFloat(237.0/255.0), green: CGFloat(237.0/255.0), blue: CGFloat(237.0/255.0), alpha: CGFloat(1.0)).cgColor
            textView.layer.borderWidth = 1.0
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.textColor == UIColor.lightGray) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if validateInput() {
            addNewComment()
        }
    }
    
}

extension AddNewCommentCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if validateInput() {
            addNewComment()
        }
    }
}
