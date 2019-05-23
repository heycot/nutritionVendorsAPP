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

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var shopName: UILabel!
    
    var shop = ShopResponse()
    var user = UserResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getUser()
    }
    
    func setupView() {
        shopName.text = shop.name
    }
    
    func showChat() {
        
        let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                              secondaryColor: UIColor(hexString: "#f0f0f0"),
                                              inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                              inputTextViewTextColor: .black,
                                              inputPlaceholderTextColor: UIColor(hexString: "#979797"))
        let channel = ATCChatChannel(id: "channel_id", name: "Chat Title")
        let viewer = ATCUser(firstName: "Florian", lastName: "Marcu")
        let chatVC = ATCChatThreadViewController(user: viewer, channel: channel, uiConfig: uiConfig)
        //         Do any additional setup after loading the view.
        self.present(chatVC, animated: true)
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
