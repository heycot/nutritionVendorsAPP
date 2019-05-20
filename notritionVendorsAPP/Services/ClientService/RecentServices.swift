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
        var list = [RecentResponse]()
        
        let db = Firestore.firestore()
        let docRef = db.collection("recent").whereField("user_id", isEqualTo: userID)
        docRef.order(by: "update_date", descending: true)
        docRef.limit(to: 20)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                print(document.documents)
                for doct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: doct.data() as Any)
                    do {
                        let recent = try JSONDecoder().decode(RecentResponse.self, from: jsonData!)
                        recent.id = doct.documentID
                        
                        list.append(recent)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(list)
                }
            } else {
                DispatchQueue.main.async {
                    completion(list)
                }
                print("User have no profile")
            }
        })
    }
    
    func saveOne(shopItemID: String) {
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef = db.collection("recent").whereField("shop_item_id", isEqualTo: shopItemID)
            .whereField("user_id", isEqualTo: userID as Any)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                var check = false
                
                for doct in document.documents{
                    check = true
                    
                    self.updateOne(recentID: doct.documentID, completion: { (data) in
                    })
                }
                
                if !check  {
                    self.addOne(itemID: shopItemID, completion: { (data) in
                    })
                }
            } else {
                self.addOne(itemID: shopItemID, completion: { (data) in
                })
            }
        })
    }
    
    func updateOne( recentID: String,  completion: @escaping (Bool?) -> Void) {
        let date = Date().timeIntervalSince1970
        
        let values = ["update_date": date] as [String : Any]
        
        let db = Firestore.firestore()
        db.collection("recent").document(recentID).updateData(values) { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    
    func addOne( itemID: String,  completion: @escaping (Bool?) -> Void) {
        let date = Date().timeIntervalSince1970
        let userID = Auth.auth().currentUser!.uid
        
        let item = ["shop_item_id": itemID as Any,
                    "create_date": date,
                    "update_date": date,
                    "user_id": userID] as [String : Any]
        
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
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
