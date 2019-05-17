//
//  ShopFirebase.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

import Firebase

class ShopFirebase {
    static let instance = ShopFirebase()

    func addNewShop(shop: ShopResponse, keyword: [String], completion: @escaping (String?, Bool?) -> Void) {
        let userID = "HWQ9thTlZMVmnKWgb5C5UP9Re0r1" //Auth.auth().currentUser!.uid
        //Truy cập vào user_profile để lấy user profile với uid
        let db = Firestore.firestore()
        let shop = [
            "user_id": userID,
            "name": shop.name as Any,
            "rating": 0.0,
            "time_open": shop.time_open as Any,
            "time_close": shop.time_close as Any,
            "create_date": Date().timeIntervalSince1970,
            "status": 0,
            "phone": shop.phone as Any,
            "avatar": shop.avatar as Any,
            "keyword": keyword as Any,
            "sell": "",
            "longitude": shop.location?.longitude as Any,
            "latitude": shop.location?.latitude as Any,
            "address": shop.location?.address as Any] as [String : Any]
        
        var ref: DocumentReference? = nil
        
        // init first to get ID
        ref = db.collection("shop").document()
        
        ref?.setData(shop, completion:{ (error) in
            DispatchQueue.main.async {
                completion(ref?.documentID, true)
            }
            
        })
    }
}
