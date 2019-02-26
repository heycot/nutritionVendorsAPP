//
//  AccountController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class AccountController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var isActive: UITextField!
    //    @IBOutlet weak var email: UITextField!
//    @IBOutlet weak var address: UITextField!
//    @IBOutlet weak var joinOn: UITextField!
//    @IBOutlet weak var changeInfor: UITextField!
//    @IBOutlet weak var changePass: UITextField!
//    @IBOutlet weak var signOut: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let titleCell = ["Email:", "Birthday:", "Address:", "Join on:", "Edit information", "Change password", "Sign out"]
    let detailCell = ["nguyentu15061996@gmail.com", "15/06/1996", "60 Ngo Sy Lien", "24/02/2019", "", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        disableUIView()
        
        setUpForTableView()
    }
    
    func setUpForTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
    }
    
    @IBAction func ChangePassClick(_ sender: Any) {
        print("click change password")
        self.performSegue(withIdentifier: "ChangePassSegue", sender: self)
    }
    
    func setUpUI() {
//        email.setBottomBorder()
//        address.setBottomBorder()
//        joinOn.setBottomBorder()
//        changeInfor.setBottomBorder()
//        changePass.setBottomBorder()
//        signOut.setBottomBorder()
//
    }
    
    @IBAction func toucDown(_ sender: Any) {
        
        print("touch change pass")
    }
    func disableUIView() {
        username.isEnabled = false
        phone.isEnabled = false
        isActive.isEnabled = false
//        email.isEnabled = false
//        address.isEnabled = false
//        joinOn.isEnabled = false
//        changeInfor.isEnabled = false
////        changePass.isEnabled = false
//        signOut.isEnabled = false
//
    }

}

extension AccountController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
        
        cell.detailTextLabel?.text = detailCell[indexPath.row]
        cell.textLabel?.text = titleCell[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
//        cellTitle.text = "Name:"
//        cellDetail.text = "Callie"
//
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //getting the text of that cell
        let currentItem = currentCell.textLabel!.text
        
        if currentItem == "Change password" {
            self.performSegue(withIdentifier: "ChangePassSegue", sender: self)
        }
        
//        let alertController = UIAlertController(title: "Simplified iOS", message: "You Selected " + currentItem! , preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
//        alertController.addAction(defaultAction)
//
//        present(alertController, animated: true, completion: nil)
    }
    
}
