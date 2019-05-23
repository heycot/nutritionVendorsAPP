//
//  SearchServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/21/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase


class SearchServices {
    
    public static let instance = SearchServices()

    func search(searchText: String, completion: @escaping ([SearchResponse]?) -> Void) {
        var results = [SearchResponse]()
        
        let searchConvert = String.convertVietNam(text: searchText)
        
        let db = Firestore.firestore()
        
        
        let docRef = db.collection("search").whereField("keywords", arrayContains: searchConvert.lowercased())
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for searchDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: searchDoct.data() as Any)
                    
                    do {
                        let search = try JSONDecoder().decode(SearchResponse.self, from: jsonData!)
                        results.append(search)
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(results)
                }
                
            } else {
                print("User have no profile")
            }
        })
        
    }
    
    
}
