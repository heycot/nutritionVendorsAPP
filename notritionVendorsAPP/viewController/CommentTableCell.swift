//
//  CommentTableCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class CommentTableCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var commentContent: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(userimage: String, username: String, cmtDate: String, cmtTitle: String, rating: Double, cmtContent: String) {
        userImage.image = UIImage(named: userimage)
        userName.text = username
        commentDate.text = cmtDate
        commentTitle.text = cmtTitle
//        viewRating.rating = rating
        commentContent.text = cmtContent
    }

}
