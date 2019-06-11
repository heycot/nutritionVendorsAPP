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
import PKHUD
import Firebase

class NewCommentController: UIViewController {
    @IBOutlet weak var shopItemName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var ratingview: CosmosView!
    @IBOutlet weak var titleCmt: UITextField!
    @IBOutlet weak var content: UITextView!
    
    var isNew = true
    var shopItem = ShopItemResponse()
    var lastComment = CommentResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(donePressed))
        
        if isNew {
            shopItemName.text = NSLocalizedString("Food :", comment: "") + " \( shopItem.name ?? "")"
            
            address.text = NSLocalizedString("Shop :", comment: "") + " \( shopItem.shop_name ?? "")"
        } else {
            shopItemName.text = NSLocalizedString("Food :", comment: "") + " \(lastComment.shop_item_name ?? "")"
            
            address.text = NSLocalizedString("Shop :", comment: "") + " \( shopItem.shop_name ?? "")"
            
        }

        setUpUI()
        handlerkeyboard()
        getReviewOfUser()
    }
    
    @objc func donePressed() {
        didPressOnDoneButton()
    }
    
    func getReviewOfUser() {
        HUD.show(.progress)
        CommentServices.instance.getCommentByUserAnShopItem(shopitemID: shopItem.id ?? "") { (data) in
            HUD.hide()
            if data == nil {
                self.title = NSLocalizedString("Write review", comment: "")
            } else {
                self.isNew = false
                self.title = NSLocalizedString("Edit review", comment: "")
                self.lastComment = data!
                self.viewLastComment(comment: data!)
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
            content.text = NSLocalizedString("Enter content", comment: "")
            content.textColor = .lightGray
        }
        
        
        ratingview.rating = 3.0
        ratingview.settings.minTouchRating = 1.0
        ratingview.settings.updateOnTouch = true
        ratingview.settings.fillMode = .precise
        ratingview.text = NSLocalizedString("Rate me", comment: "")
        
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
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = NSLocalizedString("Send", comment: "")
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.shouldPlayInputClicks = false // set to true by default
    }
    
    func validString(string: String) -> String {
        var result = ""
        var strimString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        //trim the string
        _ = strimString.trimmingCharacters(in: CharacterSet.newlines)
        // replace occurences within the string
        while let rangeToReplace = strimString.range(of: "\n\n") {
            strimString.replaceSubrange(rangeToReplace, with: "\n")
        }
        
        let resultArr  = strimString.split(separator: " ")
                
        for item in resultArr {
            result += item + " "
        }
        
        return result
    }
    
    func disableView() {
        doneBtn.isEnabled = false
        shopItemName.isEnabled = false
        address.isEnabled = false
        ratingview.settings.updateOnTouch = false
        titleCmt.isEnabled = false
        content.isEditable = false
    }
    
    
    @objc func didPressOnDoneButton() {
        if validateInput() {
            
            lastComment.user_id = Auth.auth().currentUser?.uid
            lastComment.content = validString(string: content.text)
            lastComment.title = validString(string: titleCmt.text!)
            lastComment.rating = ratingview.rating
            lastComment.status = 1
            
            
            HUD.show(.success)
            if isNew {
                
                lastComment.shop_item_id = shopItem.id
                lastComment.shop_id = shopItem.shop_id
                lastComment.shop_item_name = shopItem.name
                lastComment.shop_item_avatar = shopItem.avatar
                
                CommentServices.instance.addOne(cmt: lastComment) { (data) in
                    
                    HUD.hide()
                    if data == nil {
                        let alert = UIAlertController(title: NSLocalizedString(Notification.comment.addCmtFailedTitle.rawValue, comment: "")  , message: NSLocalizedString(Notification.comment.addCmtFailedMessgae.rawValue, comment: "")  , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        
                    } else {
                        
                        self.disableView()
                        ShopItemService.instance.editOneWhenComment(itemID: self.lastComment.shop_item_id ?? "", cmt: self.lastComment, isNewCmt: true)
                         CommentServices.instance.updateUserComment(cmtID: data ?? "")
                        //self.navigationController?.popViewController(animated: true)
                     }
                }
                
            } else {
                
                CommentServices.instance.editOne(cmt: lastComment) { (data) in
                    guard let data = data else { return }
                    
                    HUD.hide()
                    if !data {
                        let alert = UIAlertController(title: NSLocalizedString(Notification.comment.addCmtFailedTitle.rawValue, comment: "")  , message: NSLocalizedString(Notification.comment.addCmtFailedMessgae.rawValue, comment: "")  , preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        
                    } else {
                        self.disableView()
                        ShopItemService.instance.editOneWhenComment(itemID: self.lastComment.shop_item_id ?? "", cmt: self.lastComment, isNewCmt: false)
                        //self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func validateInput() -> Bool {
        
        if titleCmt.text == "" || titleCmt.text?.lowercased() == "enter title" || content.text == "" || content.text.lowercased() == "enter content" {
            showAlertError(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString(Notification.comment.nilWithInfor.rawValue, comment: "") )
            return false
        } else if !titleCmt.text!.isValidString() {
            showAlertError(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString(Notification.comment.titleNotValid.rawValue, comment: "") )
            return false
            
        } else if content.text == nil || !content.text!.isValidString() {
            showAlertError(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString(Notification.comment.contentNotValid.rawValue, comment: "") )
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
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isNew {
            if textView.text.isEmpty {
                textView.text = NSLocalizedString("Enter content", comment: "")
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
