//
//  ViewCommentCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class ViewCommentCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cmtDate: UILabel!
    @IBOutlet weak var cmtRating: UIView!
    @IBOutlet weak var cmtTitle: UILabel!
    @IBOutlet weak var cmtContent: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateView(user_image: String, user_name: String, create_date: Date, rating: Double, title: String, content: String) {
        userImage.image = UIImage(named: user_image)
        userName.text = user_name
        cmtDate.text = NSObject().convertToString(date: create_date, dateformat: DateFormatType.date)
        cmtRating = {
            let view = CosmosView()
            view.rating = rating
            return view
        }()
        cmtTitle.text = title
        cmtContent.text = content
        
        customUI()
    }
    
    func customUI() {
        userImage.setButtomBorderRadious()
        userName.setboldSystemFontOfSize(size: 17)
        cmtTitle.setboldSystemFontOfSize(size: 14)
    }
}
