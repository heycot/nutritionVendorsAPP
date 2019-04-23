//
//  ActivityCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/22/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityImage: CustomImageView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentRating: UILabel!
    @IBOutlet weak var contentDetail: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(comment: CommentDTOResponse) {
        activityImage.loadImageUsingUrlString(urlString: BASE_URL_IMAGE +  comment.entity_avatar!)
        activityTitle.text = comment.entity_name!
        contentTitle.text = comment.title!
        contentRating.text = String(format: "%0.2f", comment.rating!)
        contentDetail.text = comment.content!
        
        setupView()
    }
    
    func setupView() {
        activityImage.setRounded(color: .white)
        activityTitle.setboldSystemFontOfSize(size: 17)
        contentTitle.setboldSystemFontOfSize(size: 14)
        contentRating.setboldSystemFontOfSize(size: 14)
        contentDetail.isEditable = false
    }
    
}