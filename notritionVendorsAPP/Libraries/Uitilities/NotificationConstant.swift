//
//  NotificationConstant.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/5/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


enum Notification : String {
    case noSearchResult = ""
    
    case notLogedIn = "Please login to use this task."
    
    enum username : String {
        case title = "Invalid username!"
        case detail = "Only letters, underscores, numbers, and Length should 6-20."
    }
    
    enum phoneNumber : String {
        case title = "Invalid phone number!"
        case detail = "Only 10 numbers."
    }
    
    enum email : String {
        case title = "Invalid email address!"
        case detail = "Please enter a valid email address."
    }
    
    enum password : String {
        case title = "Invalid password"
        case detail = "Only letters, underscores, and numbers."
    }
    
    enum confirmPass : String {
        case title = "Invalid password!"
        case detail = "Does not match with password."
    }
    
    
}
