//
//  Recent.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/20/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


class RecentResponse : Decodable {
    var id:         String?
    var user_id: String?
    var shop_item_id: String?
    var create_date: TimeInterval?
    var update_date: TimeInterval?
    
    var rating:     Double?
    var comment_number: Int?
    var name:       String?
    var avatar:     String?
    var shop_id:    String?
    var shop_name:  String?
    var address:    String?
    
    
    func convertToSearchResponse() -> SearchResponse {
        var search = SearchResponse()
        
        search.is_shop = 0
        search.entity_id = self.shop_item_id
        search.address = self.address
        search.entity_name = "\(self.name ?? "") - \(self.shop_name ?? "")"
        search.avatar = self.avatar
        
        return search
    }
}
