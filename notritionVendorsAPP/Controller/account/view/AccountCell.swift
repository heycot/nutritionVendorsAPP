//
//  AccountCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/21/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    @IBOutlet weak var icon: CustomImageView!
    @IBOutlet weak var propertyName: UILabel!
    @IBOutlet weak var propertyAction: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(iconName: String , property_name: String) {
        icon.image = UIImage(named: iconName)
        propertyName.text = property_name
    }

}
