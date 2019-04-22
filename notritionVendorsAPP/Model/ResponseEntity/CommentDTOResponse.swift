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
    var create_date: Date?
    var rating: Double?
    var entity_image: String?
    var entity_name: String?
    
    init(id: Int, title: String, content: String, create_date: Date, entity_image: String, entity_name: String, rating: Double) {
        self.id = id
        self.title = title
        self.content = content
        self.create_date = create_date
        self.rating = rating
        self.entity_name = entity_name
        self.entity_image = entity_image
    }
    
    convenience init() {
        self.init(id: 0, title: "", content: "", create_date: Date(), entity_image: "", entity_name: "", rating: 0.0)
    }
}
