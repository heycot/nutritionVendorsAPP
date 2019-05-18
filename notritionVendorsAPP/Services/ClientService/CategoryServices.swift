//
//  CategoryServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

class CategoryService {
    static let instance = CategoryService()
    
    func findAll(completion: @escaping ([CategoryResponse]?) -> Void) {
     
        let db = Firestore.firestore()
        let docRef = db.collection("category")
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                var categoryList = [CategoryResponse]()
                for categoryDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: categoryDoct.data() as Any)
                    
                    do {
                        let category = try JSONDecoder().decode(CategoryResponse.self, from: jsonData!)
                        category.id = categoryDoct.documentID
                        categoryList.append(category)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(categoryList)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }

}
