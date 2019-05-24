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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if AuthServices.instance.user == nil {
            getUser()
        } else {
            user = AuthServices.instance.user!
            getShop()
        }
    }
    
    
    func showChat() {
        let urlAvatar = "/images/" + ReferenceImage.user.rawValue + "\(user.avatar ?? "")"
        let userID = Auth.auth().currentUser?.uid
        let channedl_id = shop.user_id ?? ""
        
        let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                              secondaryColor: UIColor(hexString: "#f0f0f0"),
                                              inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                              inputTextViewTextColor: .black,
                                              inputPlaceholderTextColor: UIColor(hexString: "#979797"))
        let channel = ATCChatChannel(id: channedl_id, name: titleChat)
        let viewer = ATCUser(uid: userID ?? "", firstName: user.name ?? "", lastName: "", avatarURL: urlAvatar, email: user.email ?? "", isOnline: true)
        let chatVC = ATCChatThreadViewController(user: viewer, channel: channel, uiConfig: uiConfig)
       
        chatVC.navigationItem.backBarButtonItem?.title = shop.name
        
        let navbar = addNavigationBar()
        
        chatVC.view.addSubview(navbar)
        
        chatVC.view?.frame = CGRect(x: 0, y: 75, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - 75))
        
//        self.presentedViewController(chatVC)
//        self.presentedViewController(chatVC)
        
//        self.viewChat.addSubview(chatVC.view)
        //         Do any additional setup after loading the view.
//        self.viewChat.present(chatVC, animated: true)
        
        
        self.present(chatVC, animated: true)
        
    }
    
    func getShop() {
        ShopService.instance.getOneById(shopId: shop.id ?? "") { (data) in
            guard let data = data else { return }
            
            self.shop = data
            self.showChat()
        }
    }
    
   @objc private func dismissViewController() {
//        self.navigationController?.popViewController(animated: true)
    
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    private func addNavigationBar() -> UINavigationBar {
        let height: CGFloat = 75
        let statusBarHeight = UIApplication.shared.statusBarFrame.height;
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = .white
        navbar.delegate = self as? UINavigationBarDelegate
        
        let navItem = UINavigationItem()
        navItem.title = shop.name
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissViewController))
        
        navbar.items = [navItem]
        return navbar
    }

    func getUser() {
        AuthServices.instance.checkLogedIn { (data) in
            guard let data = data else { return }
            
            if data {
                let userID = Auth.auth().currentUser?.uid
                AuthServices.instance.getProfile(userID: userID ?? "", completion: { (data) in
                    guard let data = data else { return }
                    
                    self.user = data
                    print("user chat \(data.name ?? "")" )
                    self.getShop()
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

}
