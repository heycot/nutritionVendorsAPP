//
//  DocumentResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/24/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

class DocumentResponse: Decodable {
    
    var id: Int?
    var link: String?
    
    init(id: Int, link: String) {
        self.id = id
        self.link = link
    }
    
    convenience init() {
        self.init(id: 0, link: "")
    }
}
