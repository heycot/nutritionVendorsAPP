//
//  ChannelCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/25/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var channelImage: CustomImageView!
    
    func updateView(channel: Channel, userID: String) {
        
        if userID == channel.user_id_first {
            name.text = channel.name_second
            name.setboldSystemFontOfSize(size: 18)
            channelImage.displayImage(folderPath: channel.image_second)
            channelImage.setRounded(color: .white)
        } else {
            
            name.text = channel.name_first
            name.setboldSystemFontOfSize(size: 18)
            channelImage.displayImage(folderPath: channel.image_first)
            channelImage.setRounded(color: .white)
        }
    }
}
