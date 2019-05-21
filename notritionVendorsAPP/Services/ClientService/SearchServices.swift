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

    func searchShopItem(searchText: String, completion: @escaping ([SearchResponse]?) -> Void) {
        var results = [SearchResponse]()
        
        let searchConvert = String.convertVietNam(text: searchText)
        print("search text : \(searchConvert)")
        
        
//        let searchArr = String.gennerateKeywords([searchConvert])
        let searchArr = searchConvert.split(separator: " ")
        let db = Firestore.firestore()
        
        for text in searchArr {
            let docRef = db.collection("shop_item").whereField("keywords", arrayContains: text.lowercased() )
            docRef.order(by: "comment_number", descending: true)
                .order(by: "rating", descending: true)
            docRef.limit(to: 20)
            
            docRef.getDocuments(completion: { (document, error) in
                if let document = document {
                    
                    for shopItemDoct in document.documents{
                        let jsonData = try? JSONSerialization.data(withJSONObject: shopItemDoct.data() as Any)
                        
                        do {
                            var shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: jsonData!)
                            shopItem.id = shopItemDoct.documentID
                            var search = shopItem.convertToSearchResponse()
                            let index = self.checkAlreadyExistsIntArray(list: results, id: shopItem.id ?? "")
                            
                            if index != nil {
                                results[index!].number_occurrences! += 1
                                print("already exit")
                            } else {
                                search.number_occurrences = 1
                                results.append(search)
                            }
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
    
    func checkAlreadyExistsIntArray(list: [SearchResponse], id: String) -> Int? {
        for i in 0 ..< list.count {
            if list[i].entity_id == id {
                return i
            }
        }
        
        return nil
    }
    
    
    func searchShop(searchText: String, completion: @escaping (Set<SearchResponse>?) -> Void) {
        var results = Set<SearchResponse>()
        let searchConvert = ConverHelper.convertVietNam(text: searchText)
        
        let searchArr = String.gennerateKeywords([searchConvert])
        let db = Firestore.firestore()
        
        for text in searchArr {
            let docRef = db.collection("shop").whereField("keywords", arrayContains: text)
            docRef.order(by: "comment_number", descending: true)
                .order(by: "rating", descending: true)
            docRef.limit(to: 20)
            
            docRef.getDocuments(completion: { (document, error) in
                if let document = document {
                    
                    for doct in document.documents{
                        let jsonData = try? JSONSerialization.data(withJSONObject: doct.data() as Any)
                        
                        do {
                            var shop = try JSONDecoder().decode(ShopResponse.self, from: jsonData!)
                            shop.id = doct.documentID
                            results.insert(shop.convertToSearchResponse())
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
    
}

    
extension Set {
    var array: [Element] {
        return Array(self)
    }
}
