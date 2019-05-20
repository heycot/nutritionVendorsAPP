//
//  CommentResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/23/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

class CommentResponse: Decodable {
    var id: String?
    var user_id: String?
    var shopitem_id: String?
    var shop_id: String?
    var title: String?
    var content: String?
    var create_date: TimeInterval?
    var update_date: TimeInterval?
    var rating: Double?
    var status: Int?
    var entity_name: String?
    var entity_avatar: String?
    
    var createDate: Date? {
        if let day = self.create_date {
            return Date(timeIntervalSince1970: day)
        }
        return nil
    }
    
    init(id: String, title: String, content: String, create_date: Date, rating: Double, user_id: String, shopitem_id: String, status: Int, update_date: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.create_date = create_date.timeIntervalSince1970
        self.rating = rating
        self.user_id = user_id
        self.shopitem_id = shopitem_id
        self.status = status
        self.update_date = update_date.timeIntervalSince1970
    }
    
    convenience init() {
        self.init(id: "", title: "", content: "", create_date: Date(), rating: 0.0, user_id: "", shopitem_id: "", status: 0, update_date: Date())
    }
}
