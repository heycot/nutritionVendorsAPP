
//
//  ItemFirebase.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase


class ItemFirebase {
    static let instance = ItemFirebase()
    
    func addOne(item: ItemResponse, id: String, completion: @escaping (String?, Bool?) -> Void) {
//        let userID = Auth.auth().currentUser!.uid
        //Truy cập vào user_profile để lấy user profile với uid
        let db = Firestore.firestore()
        let shop = [
            "id": item.id as Any,
            "category_id": id as Any,
            "name": item.name as Any,
            "unit": "kg" as Any] as [String : Any]
        
        var ref: DocumentReference? = nil
        
        // init first to get ID
        ref = db.collection("item").document()
        
        ref?.setData(shop, completion:{ (error) in
            DispatchQueue.main.async {
                completion(ref?.documentID, true)
            }
            
        })
    }
}

