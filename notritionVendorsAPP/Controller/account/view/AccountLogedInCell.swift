//
//  AccountLogedInCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/22/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class AccountLogedInCell: UITableViewCell {
    @IBOutlet weak var userAvatar: CustomImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateview(avatar: String, nameStr: String) {
        setupView()
        
        userAvatar.displayImage(folderPath: ReferenceImage.user.rawValue + avatar)
        name.text = nameStr
    }
    
    
    func setupView() {
        userAvatar.setRounded(color: .white)
        name.setboldSystemFontOfSize(size: 19)
//        userAvatar.setButtomBorderRadious()
    }
}
