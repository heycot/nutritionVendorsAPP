//
//  CommentResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/23/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

class CommentResponse: Decodable {
    var id: Int?
    var title: String?
    var content: String?
    var create_date: Date?
    var user: UserResponse?
    var rating: Double?
    
    init(id: Int, title: String, content: String, create_date: Date, user: UserResponse, rating: Double) {
        self.id = id
        self.title = title
        self.content = content
        self.create_date = create_date
        self.user = user 
        self.rating = rating
    }
    
    convenience init() {
        self.init(id: 0, title: "T##String", content: "", create_date: Date(), user: UserResponse(), rating: 0.0)
    }
}
