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
        
        let cateRef = db.collection("item").whereField("category_id", isEqualTo: categoryID)
        
        
        cateRef.getDocuments { (document, err) in
            if let document = document {
                for itemDoct in document.documents {
                    
                    let docRef = db.collection("shop_item").whereField("item_id", isEqualTo: itemDoct.documentID)
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
            }
        }
        
    }
    
    func editOneWhenComment( itemID: String, cmt: CommentResponse, isNewCmt: Bool,  completion: @escaping (Bool?) -> Void) {
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("shop_item").document(itemID)
        
        docRef.getDocument(completion: { (document, error) in
            if let document = document, document.exists {
                let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                do {
                    let shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: jsonData!)
                    
                    var newCommentNumber = shopItem.comment_number ?? 0
                    if isNewCmt {
                        newCommentNumber += 1
                    }
                    
                    let newRating = ((shopItem.rating ?? 0 * Double(newCommentNumber) ) + (cmt.rating ?? 3.0)) / Double(newCommentNumber)
                    
                    let values = ["comment_number": newCommentNumber as Any,
                                  "rating": newRating as Any] as [String : Any]
                    
                    db.collection("shop_item").document(itemID).updateData(values) { err in
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
                } catch let jsonError {
                    print("Error serializing json:", jsonError)
                }
                
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
    
    func getListFavorite(favorites: [FavoritesResponse], completion: @escaping ([ShopItemResponse]?) -> Void) {
        let db = Firestore.firestore()
        var listFood = [ShopItemResponse]()
        
        for item in favorites {
            let docRef = db.collection("shop_item").document(item.shop_item_id ?? "")
            
            docRef.getDocument(completion: { (document, error) in
                if let document = document, document.exists {
                    let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                    do {
                        var shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: jsonData!)
                        shopItem.id = document.documentID
                        listFood.append(shopItem)
                        
                    } catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                    
                    DispatchQueue.main.async {
                        completion(listFood)
                    }
                } else {
                    print("User have no profile")
                }
            })
        }
    }
    
    func findAllByShop(shopId: String, offset: Int, completion: @escaping ([ShopItemResponse]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("shop_item").whereField("shop_id", isEqualTo: shopId)
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
    
}
