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
    
    func checkLoveStatus(shopItemID: String, completion: @escaping (Int?) -> Void) {
        var result  = 0
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
                        
                        result = favorite.status ?? 0
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
                
            }
        })
    }
    
    func loveOne(shopItem: ShopItemResponse , completion: @escaping (Int?, Bool?) -> Void) {
        var result = false
        var status = 0
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef = db.collection("favorites").whereField("shop_item_id", isEqualTo: shopItem.id ?? "")
            .whereField("user_id", isEqualTo: userID as Any)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var check = false
                
                for favoriteDoct in document.documents{
                    check = true
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: favoriteDoct.data() as Any)
                    
                    do {
                        let favorite = try JSONDecoder().decode(FavoritesResponse.self, from: jsonData!)
                        status = favorite.status == 0 ? 1 : 0
                        self.changeStatusOne(id: favoriteDoct.documentID, status: status, completion: { (data) in
                            guard let data = data else { return }
                            
                            result = data ? true : false
                        })
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                
                if check  {
                    DispatchQueue.main.async {
                        completion(status, result)
                    }
                } else {
                    self.addOne( shopItem: shopItem, status: 1, completion: { (data) in
                        guard let data = data else { return }
                        
                        if !data {
                            DispatchQueue.main.async {
                                completion(1, false)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(1, true)
                            }
                        }
                    })
                }
                
            }
        })
    }
    
    func addOne(shopItem: ShopItemResponse, status: Int, completion: @escaping (Bool?) -> Void) {
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let values = ["user_id": userID as Any,
                      "shop_item_id": shopItem.id as Any,
                      "create_date": Date().timeIntervalSince1970,
                      "update_date": Date().timeIntervalSince1970,
                      "status": status as Any,
                      "shop_item_name": shopItem.name as Any,
                      "shop_name": shopItem.shop_name as Any,
                      "rating": shopItem.rating as Any] as [String : Any]
        
        
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
    
    func getAllLovedByUser(completion: @escaping ([FavoritesResponse]?) -> Void) {
        var favoritesList = [FavoritesResponse]()
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
                        favorite.id = favoriteDoct.documentID
                        favoritesList.append(favorite)
                        
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(favoritesList)
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(favoritesList)
                }
                print("User have no profile")
            }
        })
        
    }
    
    
    
    
}
