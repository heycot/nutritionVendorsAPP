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
    
    func updateView(comment: CommentResponse) {
        activityImage.displayImage(folderPath: ReferenceImage.shopItem.rawValue + "\(comment.shop_item_id ?? "")/\(comment.shop_item_avatar ?? "")")
        activityTitle.text = comment.shop_item_name
        contentTitle.text = comment.title!
        contentRating.text = String(format: "%0.2f", comment.rating!)
        contentDetail.text = comment.content!
        
        setupView(rating: comment.rating ?? 0.0)
    }
    
    
    
    func setupView(rating: Double) {
        activityImage.setRounded(color: .white)
        activityTitle.setboldSystemFontOfSize(size: 17)
        contentTitle.setboldSystemFontOfSize(size: 14)
        contentRating.setboldSystemFontOfSize(size: 14)
        contentDetail.isEditable = false
        
        if rating < 2.5 {
            contentRating.textColor = .red
        } else if rating >= 4 {
            contentRating.textColor = .green
        } else if rating <= 5  {
            contentRating.textColor = .orange
        } else {
            contentRating.textColor = .gray
        }
    }
    
}
