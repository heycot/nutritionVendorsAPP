//
//  RecentResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/20/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


struct RecentResponse: Decodable{
    var id:         String?
    var price:      Double?
    var status:     Int?
    var rating:     Double?
    var comment_number: Int?
    var favorites_number: Int?
    var name:       String?
    var avatar:     String?
    var unit :      String?
    var item_id:    String?
    var keywords:   [String]?
    var images :    [String]?
    var create_date: TimeInterval?
    var shop_id:    String?
    var shop_name:  String?
    var latitude:    Double?
    var longitude : Double?
    var time_open : String?
    var time_close: String?
    var phone     : String?
    var address:    String?
    var user_id: String?
    var shop_item_id : String?
}
