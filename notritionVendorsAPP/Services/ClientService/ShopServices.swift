//
//  ShopServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class ShopService {
    static let instance = ShopService()
    
    
    func getListShop( completion: @escaping ([ShopResponse]?) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        let docRef = db.collection("shop").whereField("user_id", isEqualTo: userID)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                print(document.documents)
                var shopList = [ShopResponse]()
                for shopDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: shopDoct.data() as Any)
                    do {
                        var shop = try JSONDecoder().decode(ShopResponse.self, from: jsonData!)
                        shop.id = shopDoct.documentID
                        shopList.append(shop)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(shopList)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }
    
    func getOneById(shopId: String, completion: @escaping (ShopResponse?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("shop").document(shopId)
        
        docRef.getDocument { (document, err) in
            if let document = document {
                let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                do {
                    var shop = try JSONDecoder().decode(ShopResponse.self, from: jsonData!)
                    shop.id = document.documentID
                    
                    DispatchQueue.main.async {
                        completion(shop)
                    }
                }
                catch let jsonError {
                    print("Error serializing json:", jsonError)
                }
            }
        }
    }
   
    
    func editShop(shop: ShopResponse, completion: @escaping (Bool?) -> Void) {
        
        let db = Firestore.firestore()
        
        let values = ["name": shop.name as Any,
                      "avatar": shop.avatar as Any,
                      "time_open": shop.time_open as Any,
                      "time_close": shop.time_close as Any,
                      "longitude": shop.longitude as Any,
                      "latitude": shop.latitude as Any,
                      "phone": shop.phone as Any,
                      "keyword": shop.keyword as Any,
                      "address": shop.address as Any ] as [String : Any]
        
        db.collection("shop").document(shop.id!).updateData(values) { err in
            var result = true
            if let err = err {
                result = false
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
