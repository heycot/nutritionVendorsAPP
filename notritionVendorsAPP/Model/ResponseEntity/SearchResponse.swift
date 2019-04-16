//
//  SearchResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/16/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable{
    var id: Int?
    var entity_id: Int?
    var entity_name: String?
    var rating: Double?
    var comment_number: Int?
    var address: String?
    var isShop: Int?
    var avatar: String?
    
    init(id: Int, entity_id: Int, entity_name: String, rating: Double, comment_number: Int, address: String, isShop: Int, avatar: String) {
        self.id = id
        self.entity_id = entity_id
        self.entity_name = entity_name
        self.rating = rating
        self.comment_number = comment_number
        self.address = address
        self.isShop = isShop
        self.avatar = avatar
    }
    
    init() {
        self.init(id: 0, entity_id: 0, entity_name: "", rating: 0.0, comment_number: 0, address: "", isShop: 0, avatar: "")
    }
}
