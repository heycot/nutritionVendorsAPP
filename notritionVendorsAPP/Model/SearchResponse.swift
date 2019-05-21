//
//  SearchResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/16/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable, Hashable{
    var entity_id: String?
    var entity_name: String?
    var rating: Double?
    var comment_number: Int?
    var address: String?
    var is_shop: Int?
    var avatar: String?
    var number_occurrences: Int?
    
    init( entity_id: String, entity_name: String, rating: Double, comment_number: Int, address: String, is_shop: Int, avatar: String) {
        self.entity_id = entity_id
        self.entity_name = entity_name
        self.rating = rating
        self.comment_number = comment_number
        self.address = address
        self.is_shop = is_shop
        self.avatar = avatar
    }
    
    init() {
        self.init(entity_id: "", entity_name: "", rating: 0.0, comment_number: 0, address: "", is_shop: 0, avatar: "")
    }
    
//    func convertToSearchOrder(number_occurrences: Int) -> SearchOrder {
//        var searchOrder
//
//        searchOrder.entity_id = self.entity_id
//        searchOrder.entity_name = self.entity_name
//        searchOrder.rating = self.rating
//        searchOrder.comment_number = self.comment_number
//        searchOrder.address = self.address
//        searchOrder.is_shop = self.is_shop
//        searchOrder.avatar = self.avatar
//        searchOrder.number_occurrences = number_occurrences
//
//        return searchOrder
//    }
}

struct SearchOrder: Decodable, Hashable {
    var entity_id: String?
    var entity_name: String?
    var rating: Double?
    var comment_number: Int?
    var address: String?
    var is_shop: Int?
    var avatar: String?
    var number_occurrences: Int?
    
    init( entity_id: String, entity_name: String, rating: Double, comment_number: Int, address: String, is_shop: Int, avatar: String, number: Int) {
        self.entity_id = entity_id
        self.entity_name = entity_name
        self.rating = rating
        self.comment_number = comment_number
        self.address = address
        self.is_shop = is_shop
        self.avatar = avatar
        self.number_occurrences = number
    }
    
    init() {
        self.init(entity_id: "", entity_name: "", rating: 0.0, comment_number: 0, address: "", is_shop: 0, avatar: "", number: 0)
    }
}
