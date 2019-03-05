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

class AddNewCommentCell: UITableViewCell {

    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var content: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpUI() {
        rating.settings.fillMode = .precise
        title.setBottomBorder(color: .lightGray)
        content.setBorder(with: .lightGray)
        content.text = "Comment here"
        
    }
    
}



extension AddNewCommentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter description"
            textView.textColor = UIColor.lightGray
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
    
}
