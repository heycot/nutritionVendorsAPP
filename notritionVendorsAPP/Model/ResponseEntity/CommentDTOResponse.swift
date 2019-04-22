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
    var create_date: Date?
    var update_date: Date?
    var status: Int?
    var shopitem_id: Int?
    var entity_image: String?
    var entity_name: String?
    
    init(id: Int, title: String, content: String, create_date: Date, entity_image: String, entity_name: String, rating: Double, update_date: Date, status: Int, shopitem_id: Int) {
        self.id = id
        self.title = title
        self.content = content
        self.create_date = create_date
        self.rating = rating
        self.entity_name = entity_name
        self.entity_image = entity_image
        self.update_date = update_date
        self.status = status
        self.shopitem_id = shopitem_id
    }
    
    convenience init() {
        self.init(id: 0, title: "", content: "", create_date: Date(), entity_image: "", entity_name: "", rating: 0.0, update_date: Date(), status: 0, shopitem_id: 0)
    }
}
