//
//  ChatController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/22/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UIViewController {

    @IBOutlet weak var viewChat: UIView!
    
    var shop = ShopResponse()
    var user = UserResponse()
    var titleChat: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if AuthServices.instance.user == nil {
            getUser()
        }
    }
    
    
    func showChat() {
        let userID = Auth.auth().currentUser?.uid
        let channedl_id = "\(shop.id ?? "")-\(userID ?? "")"
        
        let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                              secondaryColor: UIColor(hexString: "#f0f0f0"),
                                              inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                              inputTextViewTextColor: .black,
                                              inputPlaceholderTextColor: UIColor(hexString: "#979797"))
        let channel = ATCChatChannel(id: channedl_id, name: titleChat)
        let viewer = ATCUser(firstName: user.name ?? "Guest", lastName: "")
        let chatVC = ATCChatThreadViewController(user: viewer, channel: channel, uiConfig: uiConfig)
        
        self.viewChat.addSubview(chatVC.view)
        //         Do any additional setup after loading the view.
//        self.viewChat.present(chatVC, animated: true)
        
    }

    func getUser() {
        AuthServices.instance.checkLogedIn { (data) in
            guard let data = data else { return }
            
            if data {
                let userID = Auth.auth().currentUser?.uid
                AuthServices.instance.getProfile(userID: userID ?? "", completion: { (data) in
                    guard let data = data else { return }
                    
                    self.user = data
                    self.showChat()
                })
            } else {
                
                let alert = UIAlertController(title: "Can not love", message: "Please sign in!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.performSegue(withIdentifier: SegueIdentifier.chatToLogin.rawValue, sender: nil)
                    
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
    }
}
