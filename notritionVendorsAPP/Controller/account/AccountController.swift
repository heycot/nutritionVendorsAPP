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
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupProperty()
    }
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = APP_COLOR
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = addVersion()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
    }
    
    func addVersion() -> UILabel{
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        label.backgroundColor = .white
        label.textAlignment = NSTextAlignment.center
        label.text = "Version 1.0"
        label.isHidden = false
        label.numberOfLines = 0;
        
        return label
    }
    
    func setupProperty() {
        
        for i in 0 ..< listIcon.count {
            listAccountProperty.append(AccountProperty(icon: listIcon[i], property: listProperty[i], action: ""))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AccountDetailController {
//            let vc = segue.destination as? AccountDetailController
            
        } else if segue.destination is LoginController {
            
        }
    }

}

extension AccountController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if AuthServices.instance.isLoggedIn {
                performSegue(withIdentifier: SegueIdentifier.accountToDetail.rawValue, sender: nil)
            } else {
                
                performSegue(withIdentifier: SegueIdentifier.accountToLogin.rawValue, sender: nil)
            }
        }
    }
}

extension AccountController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.accountCell.rawValue, for: indexPath) as! AccountCell
        
        
        cell.updateView(iconName: listAccountProperty[index].icon, property_name: listAccountProperty[index].property, property_action: listAccountProperty[index].action)
        
        index = index + 1
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    
}
