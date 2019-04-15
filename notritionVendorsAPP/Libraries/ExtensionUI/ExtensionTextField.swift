//
//  ExtensionTextField.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit



extension UITextField {
//    func setBottomBorder(color: UIColor) {
//
//        self.borderStyle = .none
//        self.layer.backgroundColor = UIColor.white.cgColor
//
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = color.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 0.0
//    }
    
    func setboldSystemFontOfSize(size: Int) {
        self.font = UIFont.boldSystemFont(ofSize: CGFloat(size))
    }
}


class CustomTextFeild: UITextField {
    
    var UrlString: String?
    
    func count(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if AuthServices.instance.isLoggedIn {
            request.addValue(AuthServices.instance.authToken, forHTTPHeaderField: "Authorization")
        } else {
            request.addValue("", forHTTPHeaderField: "Authorization")
        }
        
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                let stringInt = String.init(data: data!, encoding: String.Encoding.utf8)
                let int = Int.init(stringInt!)
                
                self.text = String(int!)
            }
        }).resume()
    }
}


class CustomTextFeildRating: UITextField {
    
    var UrlString: String?
    
    func getRating(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if AuthServices.instance.isLoggedIn {
            request.addValue(AuthServices.instance.authToken, forHTTPHeaderField: "Authorization")
        } else {
            request.addValue("", forHTTPHeaderField: "Authorization")
        }
        
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                let ratingStr = String.init(data: data!, encoding: String.Encoding.utf8)
                let rating = Double.init(ratingStr!)
                
                self.text = String(format: "%.2f", rating!)
            }
        }).resume()
    }
}
