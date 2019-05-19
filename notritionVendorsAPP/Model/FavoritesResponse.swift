//
//  FavoritesResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
class FavoritesResponse : Decodable {
    var id: Int?
    var shopitem_id: Int?
    var user_id: Int?
    var status: Int?
    
    init(id: Int, shopitem_id: Int, user_id: Int, status: Int) {
        self.id = id
        self.shopitem_id = shopitem_id
        self.user_id = user_id
        self.status = status
    }
    
    convenience init() {
        self.init(id: 0, shopitem_id: 0, user_id: 0, status: 0)
    }
}
