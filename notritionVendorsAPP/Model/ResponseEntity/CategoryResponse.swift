//
//  Category.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class CategoryResponse : Decodable {
    var id: Int?
    var name: String?
    var icon: String?
    
    init(id: Int, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
    
    convenience init() {
        self.init(id: 0, name: "", icon: "")
    }
}
