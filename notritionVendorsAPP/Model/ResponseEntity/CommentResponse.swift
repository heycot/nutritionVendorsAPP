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
    var create_date: Double?
    var user: UserResponse?
    var rating: Double?
    
    var createDate: Date? {
        if let day = self.create_date {
            return Date(timeIntervalSince1970: day / 1000)
        }
        return nil
    }
    
    init(id: Int, title: String, content: String, create_date: Date, user: UserResponse, rating: Double) {
        self.id = id
        self.title = title
        self.content = content
        self.create_date = create_date.timeIntervalSince1970
        self.user = user 
        self.rating = rating
    }
    
    convenience init() {
        self.init(id: 0, title: "T##String", content: "", create_date: Date(), user: UserResponse(), rating: 0.0)
    }
}
