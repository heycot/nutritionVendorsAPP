//
//  AccountController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class AccountDetailController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userAvatar: CustomImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var inforUser: UITextField!
    @IBOutlet weak var activitiesBtn: UIButton!
    @IBOutlet weak var accountBtn: UIButton!
    
    let titleCell = ["Email:", "Birthday:", "Address:", "Join on:", "Edit information", "Change password", "Sign out"]
    let detailCell = ["nguyentu15061996@gmail.com", "15/06/1996", "60 Ngo Sy Lien", "24/02/2019", "", "", ""]
    
    var user = UserResponse()
    var listComment = [CommentDTOResponse]()
    var isActivity = true
    
    @IBAction func activitiesBtnPressed(_ sender: Any) {
    }
    
    @IBAction func accountBtnPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setUpUI()
        disableUIView()
        
        setUpForTableView()
        
        viewInfor()
    }
    
    func registerCells() {
        
        tableView.register(UINib(nibName: CellClassName.activityCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.activityCell.rawValue)
        
        tableView.register(UINib(nibName: CellClassName.inforCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.inforCell.rawValue)
    }
    
    func viewInfor() {
        userAvatar.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + user.avatar!)
        userAvatar.setRounded(color: .white)
        username.text = user.name!
        inforUser.text = "newbee - Top 1000 - 10 Followers"
        
        username.setboldSystemFontOfSize(size: 18)
        inforUser.setboldSystemFontOfSize(size: 14)
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
    
    func setUpUI() {
    }
    
    func disableUIView() {
        username.isEnabled = false
    }

}

extension AccountDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isActivity ? listComment.count : 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isActivity {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.activityCell.rawValue, for: indexPath) as! ActivityCell
            cell.updateView(comment: listComment[indexPath.row])
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.accountInforCell.rawValue, for: indexPath)
            
            cell.detailTextLabel?.text = detailCell[indexPath.row]
            cell.textLabel?.text = titleCell[indexPath.row]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            
            return cell
        }
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
        
    }
    
}
