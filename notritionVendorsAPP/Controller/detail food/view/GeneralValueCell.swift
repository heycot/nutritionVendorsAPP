//
//  GeneralValueCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class GeneralValueCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView(icon_image: String, value: String) {
        icon.image = UIImage(named: icon_image)
        iconValue.text = value
    }
    
    
    
}
