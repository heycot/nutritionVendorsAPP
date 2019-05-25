//
//  ChatController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/25/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser != nil {
            let userID = Auth.auth().currentUser?.uid
            AuthServices.instance.getProfile(userID: userID ?? "") { (data) in
                guard let data = data else { return }
                
                
                let vc = ChannelsViewController(currentUser: data)
               // self.navigationController?.pushViewController(vc, animated: true)
               let rootViewController = NavigationController(vc)

                self.view = vc.view
//                self.present(rootViewController, animated: true, completion: {
                
//                })
            }
        } else {
            
        }
    }
    

}
