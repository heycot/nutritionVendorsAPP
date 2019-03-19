//
//  ShopResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/19/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

struct ShopItemResponse : Decodable{
    let id: Int?
    let price: Double?
    let status: Int?
    let rating: Double?
    let name: String?
    let avaar: String?
}
