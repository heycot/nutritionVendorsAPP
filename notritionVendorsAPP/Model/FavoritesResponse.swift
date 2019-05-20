//
//  FavoritesResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
class FavoritesResponse : Decodable {
    var id: String?
    var shop_item_id: String?
    var user_id: String?
    var status: Int?
    var create_date : TimeInterval?
    var update_date : TimeInterval?
    var shop_item_name: String?
    var shop_name: String?
    var rating: Double?
    
    
    init(id: String, shop_item_id: String, user_id: String, status: Int) {
        self.id = id
        self.shop_item_id = shop_item_id
        self.user_id = user_id
        self.status = status
    }
    
    convenience init() {
        self.init(id: "", shop_item_id: "", user_id: "", status: 0)
    }
}
