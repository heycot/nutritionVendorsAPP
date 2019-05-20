//
//  RecentServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/20/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase



class RecentService {
    static let instance = RecentService()
    
    
    func getListRecent( completion: @escaping ([RecentResponse]?) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        var shopList = [RecentResponse]()
        
        let db = Firestore.firestore()
        let docRef = db.collection("recent").whereField("user_id", isEqualTo: userID).limit(to: 20)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                print(document.documents)
                for shopDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: shopDoct.data() as Any)
                    do {
                        var shop = try JSONDecoder().decode(RecentResponse.self, from: jsonData!)
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
                DispatchQueue.main.async {
                    completion(shopList)
                }
                print("User have no profile")
            }
        })
    }
    
    
    
//    func ViewOne( shopItem: ShopItemResponse,  completion: @escaping (Bool?) -> Void) {
//        var result = false
//        var status = 0
//        let userID = Auth.auth().currentUser?.uid
//        let db = Firestore.firestore()
//        let docRef = db.collection("recent").whereField("shop_item_id", isEqualTo: shopItem.id ?? "")
//            .whereField("user_id", isEqualTo: userID as Any)
//
//        docRef.getDocuments(completion: { (document, error) in
//            if let document = document {
//                var check = false
//
//                for favoriteDoct in document.documents{
//                    check = true
//
//                    let jsonData = try? JSONSerialization.data(withJSONObject: favoriteDoct.data() as Any)
//
//                    do {
//                        let favorite = try JSONDecoder().decode(FavoritesResponse.self, from: jsonData!)
//                        status = favorite.status == 0 ? 1 : 0
//                        self.changeStatusOne(id: favoriteDoct.documentID, status: status, completion: { (data) in
//                            guard let data = data else { return }
//
//                            result = data ? true : false
//                        })
//                    }
//                    catch let jsonError {
//                        print("Error serializing json:", jsonError)
//                    }
//                }
//
//                if check  {
//                    DispatchQueue.main.async {
//                        completion(status, result)
//                    }
//                } else {
//                    self.addOne( shopItem: shopItem, status: 1, completion: { (data) in
//                        guard let data = data else { return }
//
//                        if !data {
//                            DispatchQueue.main.async {
//                                completion(1, false)
//                            }
//                        } else {
//                            DispatchQueue.main.async {
//                                completion(1, true)
//                            }
//                        }
//                    })
//                }
//
//            }
//        })
//    }
//
//    func update
    
    func addOne( item: ShopItemResponse,  completion: @escaping (Bool?) -> Void) {
        let date = Date().timeIntervalSince1970
        let userID = Auth.auth().currentUser!.uid
        
        let item = ["name": item.name as Any,
                    "avatar": item.avatar ?? "logo" as Any,
                    "comment_number": 0,
                    "favorites_number": 0,
                    "create_date": date,
                    "rating": 0.0,
                    "shop_id": item.shop_id as Any,
                    "shop_name": item.shop_name as Any,
                    "status": 1,
                    "unit": item.unit as Any,
                    "keywords": item.keywords as Any,
                    "item_id": item.item_id as Any,
                    "images": item.images as Any,
                    "price": item.price as Any,
                    "user_id": userID] as [String : Any]
        
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        // init first to get ID
        ref = db.collection("recent").document()
        
        ref?.setData(item, completion:{ (error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            
        })
    }

}
