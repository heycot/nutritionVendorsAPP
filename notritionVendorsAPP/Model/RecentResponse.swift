//
//  Recent.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/20/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


class RecentResponse : Decodable {
    var id: String?
    var user_id: String?
    var shop_item_id: String?
    var create_date: TimeInterval?
    var update_date: TimeInterval?
   
    
//    var createDate: Date? {
//        if self.create_date != nil {
//            return Date(timeIntervalSince1970: create_date ?? 0)
//        }
//        return nil
//    }
//    
//    var updateDate: Date? {
//        if self.update_date != nil {
//            return Date(timeIntervalSince1970: update_date ?? 0)
//        }
//        return nil
//    }
}
