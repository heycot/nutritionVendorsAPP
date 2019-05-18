//
//  ShopItemService.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/19/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

class ShopItemService {
    
    public static let instance = ShopItemService()
    
    func getHighRatingItem(offset: Int, completion: @escaping ([ShopItemResponse]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("shop_item")
        docRef.order(by: "comment_number", descending: true)
              .order(by: "rating", descending: true)
            .start(at: [offset])
            .limit(to: 20)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var shopItemList = [ShopItemResponse]()
                
                for shopItemDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: shopItemDoct.data() as Any)
                    
                    do {
                        var shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: jsonData!)
                        shopItem.id = shopItemDoct.documentID
                        shopItemList.append(shopItem)
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
    
    func findAllByCategory(categoryID: String, offset: Int,  completion: @escaping ([ShopItemResponse]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("shop_item").whereField("category_id", isEqualTo: categoryID)
        docRef.order(by: "comment_number", descending: true)
            .order(by: "rating", descending: true)
            .limit(to: 20)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var shopItemList = [ShopItemResponse]()
                
                for shopItemDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: shopItemDoct.data() as Any)
                    
                    do {
                        var shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: jsonData!)
                        shopItem.id = shopItemDoct.documentID
                        shopItemList.append(shopItem)
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
    
    
    func getOneById( shop_item_id: String, completion: @escaping (ShopItemResponse?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("shop_item").document(shop_item_id)
        
        docRef.getDocument(completion: { (document, error) in
            if let document = document, document.exists {
                let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                do {
                    var shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: jsonData!)
                    shopItem.id = document.documentID
                    
                    DispatchQueue.main.async {
                        completion(shopItem)
                    }
                } catch let jsonError {
                    print("Error serializing json:", jsonError)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }
    
    func findAllByShop(shopId: String, offset: Int, completion: @escaping ([ShopItemResponse]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("shop_item").whereField("category_id", isEqualTo: shopId)
        docRef.order(by: "comment_number", descending: true)
            .order(by: "rating", descending: true)
            .limit(to: 20)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var shopItemList = [ShopItemResponse]()
                
                for shopItemDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: shopItemDoct.data() as Any)
                    
                    do {
                        var shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: jsonData!)
                        shopItem.id = shopItemDoct.documentID
                        shopItemList.append(shopItem)
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
    

    func findAllLoved(offset: Int, completion: @escaping ([ShopItemResponse]?) -> Void) {
//        let urlStr = BASE_URL + ShopItemAPI.getAllLoved.rawValue + "/" + String(offset)
//
//        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
//            guard let data = data else {return}
//            do {
//                let shopItems = try JSONDecoder().decode([ShopItemResponse].self, from: data)
//                DispatchQueue.main.async {
//                    completion(shopItems)
//                }
//            } catch let jsonError {
//                print("Error serializing json:", jsonError)
//            }
//        }
    }
    
    
    
}
