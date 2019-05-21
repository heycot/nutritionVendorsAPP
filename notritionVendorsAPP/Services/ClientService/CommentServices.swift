//
//  CommentServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/9/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase


class CommentServices {
    
    public static let instance = CommentServices()
    
    func getCommentsByShopItem(shopItemID: String, completion: @escaping ([CommentResponse]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("comment").whereField("shop_item_id", isEqualTo: shopItemID)
        docRef.order(by: "update_date", descending: true)
            .limit(to: 6)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var cmtList = [CommentResponse]()
                
                for cmtDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: cmtDoct.data() as Any)
                    
                    do {
                        let cmt = try JSONDecoder().decode(CommentResponse.self, from: jsonData!)
                        cmt.id = cmtDoct.documentID
                        cmtList.append(cmt)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(cmtList)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }
    
    
    func getAllCommentByUser( completion: @escaping ([CommentResponse]?) -> Void) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let docRef = db.collection("comment").whereField("user_id", isEqualTo: userID)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var cmts = [CommentResponse]()
                
                for cmtDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: cmtDoct.data() as Any)
                    
                    do {
                        let cmt = try JSONDecoder().decode(CommentResponse.self, from: jsonData!)
                        cmt.id = cmtDoct.documentID
                        cmts.append(cmt)
                    }catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(cmts)
                }
                
            } else {
                print("User have no comment")
            }
        })
    }
    
    func getCommentByUserAnShopItem(shopitemID: String, completion: @escaping (CommentResponse?) -> Void) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let docRef = db.collection("comment").whereField("user_id", isEqualTo: userID)
                                            .whereField("shop_item_id", isEqualTo:shopitemID)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for cmtDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: cmtDoct.data() as Any)
                    
                    do {
                        let cmt = try JSONDecoder().decode(CommentResponse.self, from: jsonData!)
                        cmt.id = cmtDoct.documentID
                        DispatchQueue.main.async {
                            completion(cmt)
                        }
                    }catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
            } else {
                print("User have no comment")
            }
        })
    }
    
    func addOne(cmt: CommentResponse, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        
        let values = [  "user_id": cmt.user_id as Any,
                        "shop_item_id": cmt.shop_item_id as Any,
                        "shop_id": cmt.shop_id as Any,
                        "title": cmt.title as Any,
                        "content": cmt.content as Any,
                        "create_date": Date().timeIntervalSince1970,
                        "update_date": Date().timeIntervalSince1970,
                        "rating": cmt.rating as Any,
                        "status": 1] as [String : Any]
        
        db.collection("comment").document().setData(values) { err in
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
    
    func editOne(cmt: CommentResponse, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        
        let values = ["title": cmt.title as Any,
                      "rating": cmt.rating as Any,
                      "content": cmt.content as Any,
                      "update_date": cmt.update_date as Any] as [String : Any]
        
        db.collection("comment").document(cmt.id ?? "").updateData(values) { err in
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
    
    func getCommentByShopId(shopID: String, completion: @escaping ([CommentResponse]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("comment").whereField("shop_id", isEqualTo: shopID).limit(to: 30)
        docRef.order(by: "update_date", descending: true)
        //            .order(by: "update_date", descending: true)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var cmts = [CommentResponse]()
                
                for cmtDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: cmtDoct.data() as Any)
                    
                    do {
                        let cmt = try JSONDecoder().decode(CommentResponse.self, from: jsonData!)
                        cmt.id = cmtDoct.documentID
                        cmts.append(cmt)
                    }catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(cmts)
                }
                
            } else {
                print("User have no comment")
            }
        })
    }
    
    func changeStatus(cmtID: String, status: Int, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        
        let values = ["status": status as Any] as [String : Any]
        
        db.collection("comment").document(cmtID).updateData(values) { err in
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
    
    func deleteOne(cmtID: String, completion: @escaping (Bool?) -> Void) {
        let db = Firestore.firestore()
        
        
        db.collection("comment").document(cmtID).delete() { err in
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

