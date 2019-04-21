//
//  SearchServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/21/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


class SearchServices {
    
    public static let shared = SearchServices()

    func searchItem(searchText: String, completion: @escaping ([SearchResponse]?) -> Void) {
        let urlStr = BASE_URL + ShopItemAPI.searchOne.rawValue  + "/" + searchText

        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let shopItems = try JSONDecoder().decode([SearchResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(shopItems)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    func getRecentSearch(offset: Int, completion: @escaping ([SearchResponse]?) -> Void) {
        let urlStr = BASE_URL + SearchAPI.recentSearch.rawValue + "/\(offset)"
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let shopItems = try JSONDecoder().decode([SearchResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(shopItems)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
}
    
