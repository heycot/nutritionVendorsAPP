//
//  ChannelUser.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


struct ChannelUser : Decodable{
    
    var id: String?
    var name: String
    var folder_image: String
    
    init(name: String, folder_image: String) {
        id = nil
        self.name = name
        self.folder_image = folder_image
    }
    
    init() {
        self.init(name: "", folder_image: "")
    }
}

