//
//  Comment.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class Comment {
    var id: Int
    var user_id: Int
    var shopItem_id: Int
    var father_id: Int
    var content: String
    var rating: Double
    var create_date: Date
    var status: Int
    
    
    init(id: Int, user_id: Int, shopItem_id: Int, father_id: Int, content: String, rating: Double, create_date: Date, status: Int) {
        self.id = id
        self.user_id = user_id
        self.shopItem_id = shopItem_id
        self.father_id = father_id
        self.content = content
        self.rating = rating
        self.create_date = create_date
        self.status = status
    }
    
    convenience init() {
        self.init(id: 0, user_id: 0, shopItem_id: 0, father_id: 0, content: "", rating: 0.0, create_date: Date(), status: 0)
    }
}