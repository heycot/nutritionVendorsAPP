//
//  Document.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class Document: Decodable {
    var id: Int?
    var priority: Int?
    var link: String
    
    init(id: Int, shopItem_id: Int, link: String) {
        self.id = id
        self.priority = shopItem_id
        self.link = link
    }
    
    convenience init() {
        self.init(id: 0, shopItem_id: 0, link: "")
    }
}
