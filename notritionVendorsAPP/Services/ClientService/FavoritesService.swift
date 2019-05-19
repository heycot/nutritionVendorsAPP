//
//  FavoritesService.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

class FavoritesService {
    
    public static let instance = FavoritesService()
    
    func checkLoveStatus(shopItemID: String, completion: @escaping (Bool?) -> Void) {
        var result  = false
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef = db.collection("favorites").whereField("shop_item_id", isEqualTo: shopItemID)
                                                .whereField("user_id", isEqualTo: userID as Any)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for favoriteDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: favoriteDoct.data() as Any)
                    
                    do {
                        let favorite = try JSONDecoder().decode(FavoritesResponse.self, from: jsonData!)
                        
                        result = favorite.status == 0 ? false : true
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        })
    }
    
    func loveOne(shopItemID: String , status: Int, completion: @escaping (Int?, Bool?) -> Void) {
        var result = false
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef = db.collection("favorites").whereField("shop_item_id", isEqualTo: shopItemID)
            .whereField("user_id", isEqualTo: userID as Any)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for favoriteDoct in document.documents{
                    
                    self.changeStatusOne(id: favoriteDoct.documentID, status: status, completion: { (data) in
                        guard let data = data else { return }
                        
                        result = data ? true : false
                    })
                }
                DispatchQueue.main.async {
                    completion(status, result)
                }
                
            } else {
                self.addOne(id: shopItemID, status: 1, completion: { (data) in
                    guard let data = data else { return }
                    
                    if !data {
                        DispatchQueue.main.async {
                            completion(status, false)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(status, true)
                        }
                    }
                })
            }
        })
    }
    
    func addOne(id: String, status: Int, completion: @escaping (Bool?) -> Void) {
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let values = ["user_id": userID as Any,
                      "shop_item_id": id as Any,
                      "create_date": Date().timeIntervalSince1970,
                      "update_date": Date().timeIntervalSince1970,
                      "status": status as Any] as [String : Any]
        
        
        db.collection("favorites").document().setData(values) { err in
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
    
    func changeStatusOne(id: String, status: Int, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        let values = ["status": status as Any] as [String : Any]
        
        
        db.collection("favorites").document(id).updateData(values) { err in
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
    
    func getAllLovedByUser(completion: @escaping ([ShopItemResponse]?) -> Void) {
        var shopItemList = [ShopItemResponse]()
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef = db.collection("favorites")
            .whereField("user_id", isEqualTo: userID as Any)
            .whereField("status", isEqualTo: 1 as Any)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for favoriteDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: favoriteDoct.data() as Any)
                    
                    do {
                        let favorite = try JSONDecoder().decode(FavoritesResponse.self, from: jsonData!)
                        
                        ShopItemService.instance.getOneById(shop_item_id: favorite.shopitem_id ?? "", completion: { (data) in
                            guard let data = data else { return }
                            
                            shopItemList.append(data)
                        })
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(shopItemList)
                }
                
            } else {
                print("User have no profile")
            }
        })
        
    }
    
    
    
    
}
