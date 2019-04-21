//
//  AccountController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/21/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

struct AccountProperty {
    var icon : String
    var property : String
    var action : String
}

class AccountController: UIViewController {
    
    // oulets
    @IBOutlet weak var tableView: UITableView!
    
    var listAccountProperty = [AccountProperty]()
    var listIcon = ["login", "payment", "history", "promo_code", "website", "invite_friends", "email", "policy", "settings", "logout"]
    
    var listProperty = ["Login", "Payment", "History", "My Promo Code", "For Shop Owner", "Invite Friends", "Feedback", "User Policy", "App Settings", "Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupProperty()

    }
    
    func setupProperty() {
        
        for i in 0 ..< listIcon.count {
            listAccountProperty.append(AccountProperty(icon: listIcon[i], property: listProperty[i], action: ""))
        }
    }
    

}

extension AccountController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
}

extension AccountController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProperty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.accountCell.rawValue, for: indexPath) as! AccountCell
        
        cell.updateView(iconName: listAccountProperty[indexPath.row].icon, property_name: listAccountProperty[indexPath.row].property, property_action: listAccountProperty[indexPath.row].action)
        return cell
    }
    
    
}
