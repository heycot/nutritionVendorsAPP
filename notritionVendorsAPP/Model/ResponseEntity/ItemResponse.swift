//
//  ItemResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class ItemResponse : Decodable {
    var id: Int?
    var name: String?
    var category : CategoryResponse?
    
    init(id: Int, name: String, icon: String) {
        self.id = id
        self.name = name
    }
    
    convenience init() {
        self.init(id: 0, name: "", icon: "")
    }
}
