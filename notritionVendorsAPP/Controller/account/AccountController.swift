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
    
    var listProperty = [AccountProperty]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func setupProperty() {
        
    }
    

}

extension AccountController : UITableViewDelegate {
    
}

extension AccountController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProperty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.accountCell.rawValue, for: indexPath) as! AccountCell
        
        cell.updateView(iconName: listProperty[indexPath.row].icon, property_name: listProperty[indexPath.row].property, property_action: listProperty[indexPath.row].action)
        return cell
    }
    
    
}
