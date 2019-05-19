//
//  CommentDTOResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/22/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

class CommentDTOResponse: Decodable {
    var id: Int?
    var title: String?
    var content: String?
    var rating: Double?
    var create_date: Double?
    var update_date: Double?
    var status: Int?
    var shopitem_id: Int?
    var entity_avatar: String?
    var entity_name: String?
    
    var createDate: Date? {
        if let day = self.create_date {
            return Date(timeIntervalSince1970: day / 1000)
        }
        return nil
    }
    
    var updateDate: Date? {
        if let day = self.update_date {
            return Date(timeIntervalSince1970: day / 1000)
        }
        return nil
    }
    
    init(id: Int, title: String, content: String, create_date: Date, entity_avatar: String, entity_name: String, rating: Double, update_date: Date, status: Int, shopitem_id: Int) {
        self.id = id
        self.title = title
        self.content = content
        self.create_date = create_date.timeIntervalSince1970
        self.rating = rating
        self.entity_name = entity_name
        self.entity_avatar = entity_avatar
        self.update_date = update_date.timeIntervalSince1970
        self.status = status
        self.shopitem_id = shopitem_id
    }
    
    convenience init() {
        self.init(id: 0, title: "", content: "", create_date: Date(), entity_avatar: "", entity_name: "", rating: 0.0, update_date: Date(), status: 0, shopitem_id: 0)
    }
}
