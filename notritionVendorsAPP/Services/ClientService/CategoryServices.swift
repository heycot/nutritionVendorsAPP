//
//  CategoryServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/8/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

class CategoryService {
    static let shared = CategoryService()
    
    func findAll(completion: @escaping ([CategoryResponse]?) -> Void) {
        let urlStr = BASE_URL + CategoryAPI.findAll.rawValue
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let shopItems = try JSONDecoder().decode([CategoryResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(shopItems)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }

}
