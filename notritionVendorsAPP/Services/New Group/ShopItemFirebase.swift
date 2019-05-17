
//
//  ShopItemFirebase.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

class ShopItemFirebase {
    static let instance = ShopItemFirebase()
    
    func addOne( item: ShopItemResponse, shopid: String, key: [String], itemid: String,  completion: @escaping (String?) -> Void) {
        let date = Date().timeIntervalSince1970
        
        let item = ["name": item.name as Any,
                    "avatar": item.avatar ?? "logo" as Any,
                    "comment_number": 0,
                    "favorites_number": 0,
                    "create_date": date,
                    "rating": 0.0,
                    "shop_id": shopid as Any,
                    "shop_name": item.shop_name as Any,
                    "status": 1,
                    "unit": item.unit as Any,
                    "keywords": key as Any,
                    "item_id": itemid as Any,
                    "images": item.avatar as Any,
                    "price": item.price as Any] as [String : Any]
        
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        // init first to get ID
        ref = db.collection("shop_item").document()
        
        ref?.setData(item, completion:{ (error) in
            DispatchQueue.main.async {
                completion(ref?.documentID)
            }
            
        })
    }
    
}
