//
//  ChannelServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

class ChannelServices {
    
    static let instance = ChannelServices()
    
    func checkChannel(channel: Channel, userID: String,  completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        var exists = false 
        
        let docRef = db.collection("channels").whereField("users", arrayContains: userID as Any).whereField("name", isEqualTo: channel.name)
        
        docRef.getDocuments { (document, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            if let document = document {
                
                for doc in document.documents {
                    exists = true
                    DispatchQueue.main.async {
                        completion(doc.documentID)
                    }
                    
                }
                
                if !exists {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
}
