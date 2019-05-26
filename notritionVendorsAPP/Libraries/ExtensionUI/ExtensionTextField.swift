//
//  ExtensionTextField.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit



extension UITextField {
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
                guard let data = data else { return }
                let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                let intStr = stringInt ?? "0"
                let int = Int.init(intStr)
                
                self.text = String(int ?? 0)
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
                guard let data = data else { return }
                let ratingStr = String.init(data: data, encoding: String.Encoding.utf8)
                let raStr = ratingStr ?? "0.0"
                let rating = Double.init(raStr)
                let showRating = rating?.rounded()
                
                self.text = String(format: "%.2f", showRating ?? 0.0)
            }
        }).resume()
    }
}
