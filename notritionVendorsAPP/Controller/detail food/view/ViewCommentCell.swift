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
    @IBOutlet weak var userImage: CustomImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cmtDate: UILabel!
    @IBOutlet weak var cmtRating: CosmosView!
    @IBOutlet weak var cmtTitle: UILabel!
    @IBOutlet weak var cmtContent: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func updateView(comment: CommentResponse) {
        getUserInfor(userID: comment.user_id ?? "")
        cmtDate.text = NSObject().convertToString(date: comment.createDate ?? Date() , dateformat: DateFormatType.date)
        cmtRating.rating = comment.rating ??  0.0
        cmtTitle.text = comment.title
        cmtContent.text = comment.content
        
        customUI()
    }
    
    func getUserInfor(userID: String) {
        AuthServices.instance.getProfile(userID: userID) { (data) in
            guard let data = data else { return }
            
            self.updateCommentView(user: data)
        }
    }
    
    func updateCommentView(user: UserResponse) {
        userImage.loadImageFromFirebase(folder: ReferenceImage.user.rawValue + (user.avatar ?? "") )
        userName.text = user.name
    }
    
    func customUI() {
        cmtRating.settings.updateOnTouch = false
        cmtRating.settings.fillMode = .precise
        
        userImage.setRounded(color: .white)
        userName.setboldSystemFontOfSize(size: 17)
        cmtTitle.setboldSystemFontOfSize(size: 14)
    }
   
    
}
