//
//  ChatController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/22/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ChatController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var shopName: UILabel!
    
    var shop = ShopResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

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
    
    func setupView() {
        shopName.text = shop.name
    }


    @IBAction func backBtnPressed(_ sender: Any) {
    }
}
