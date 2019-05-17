//
//  CommentFirebase.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

class CommentFirebase {
    static let instance = CommentFirebase()
    
//    func addOne(cmt: CommentResponse, completion: @escaping (Bool?) -> Void) {
//        let db = Firestore.firestore()
//        
//        let values = ["title": cmt.title as Any,
//                      "rating": cmt.rating as Any,
//                      "content": cmt.content as Any,
//                      "update_date": cmt.update_date as Any] as [String : Any]
//        
//        db.collection("comment").document(cmt.id ?? "").updateData(values) { err in
//            var result = true
//            if let err = err {
//                result = false
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//            
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//    }
    
    
}
