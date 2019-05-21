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
    
    let titleCell = ["Email:", "Birthday:", "Address:", "Join on:", "Edit information", "Change password"]
    var detailCell = [String]()
    
    var user = UserResponse()
    var listComment = [CommentResponse]()
    var isActivity = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        disableUIView()
        
        setUpForTableView()
        
    }
    
    func registerCells() {
        
        tableView.register(UINib(nibName: CellClassName.activityCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.activityCell.rawValue)
        
    }
    
    func viewInfor() {
        userAvatar.displayImage(folderPath: ReferenceImage.user.rawValue + "\(user.avatar ?? "")")
        userAvatar.setRounded(color: .white)
        username.text = user.name!
        inforUser.text = "newbee - Top 1000 - 10 Followers"
        
        inforUser.setboldSystemFontOfSize(size: 14)
        username.setboldSystemFontOfSize(size: 18)
    }
    
    func setupDetailInfor() {
        
        detailCell.append(user.email!)
        
        if (user.birthday != nil) {
            let dateStr = NSObject().convertToString(date: user.birthdayDate! , dateformat: DateFormatType.date)
            detailCell.append(dateStr)
        } else {
            detailCell.append("")
        }
        
        let createDate = NSObject().convertToString(date: user.createDate! , dateformat: DateFormatType.date)
        
        detailCell.append(user.address!)
        detailCell.append(createDate)
        detailCell.append("")
        detailCell.append("")
        viewInfor()
    }
    
    func setUpForTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func activitiesBtnPressed(_ sender: Any) {
        isActivity = true
        tableView.reloadData()
    }
    
    @IBAction func accountBtnPressed(_ sender: Any) {
        isActivity = false
        tableView.reloadData()
    }
    
    
    func getDataFromAPI(offset: Int, isLoadMore: Bool) {
        
        CommentServices.instance.getAllCommentByUser { (data) in
            guard let data = data else { return }
            
            self.listComment = data
            self.setupDetailInfor()
            self.tableView.reloadData()
        }
    }
    
    func disableUIView() {
        username.isEnabled = false
    }
    
    @objc func activityPressedFunction(btn: UIButton) {
        
        
//        performSegueFunc(identifier: SegueIdentifier.detailToDelivery.rawValue)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewCommentController {
            let vc = segue.destination as? NewCommentController
            let index = sender as! Int
            
            vc?.lastComment =  listComment[index]
            vc?.isNew = false
        } else if segue.destination is ChangePasswordController {
            
        } else if segue.destination is EditInforUserController {
            let vc = segue.destination as? EditInforUserController
            vc?.user = user
        }
    }
    
}

extension AccountDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isActivity ? listComment.count : titleCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isActivity {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.activityCell.rawValue, for: indexPath) as! ActivityCell
            
//            cell.activityImage.addTarget(self, action: #selector(activityPressedFunction), for: UIControl.Event.touchDown)
//            cell.activityTitle.addTarget(self, action: #selector(activityPressedFunction), for: UIControl.Event.touchDown)
            
            cell.updateView(comment: listComment[indexPath.row])
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.accountInforCell.rawValue, for: indexPath) 
            
            cell.detailTextLabel?.text = detailCell[indexPath.row]
            cell.textLabel?.text = titleCell[indexPath.row]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
            
            if indexPath.row < (titleCell.count - 2) {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            }
            
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        getDataFromAPI(offset: 0, isLoadMore: false)
        isActivity = true
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if isActivity {
            performSegue(withIdentifier: SegueIdentifier.accountToComment.rawValue, sender: indexPath?.row)
        }
        
        else {
            let index = titleCell.count - 1
            if indexPath?.row == index  {
                performSegue(withIdentifier: SegueIdentifier.accountToPassword.rawValue, sender: nil)
            } else {
                performSegue(withIdentifier: SegueIdentifier.accountToEditInfor.rawValue, sender: nil)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            CommentServices.instance.deleteOne(cmtID: listComment[indexPath.row].id ?? "") { (data) in
                guard let data = data else { return }
                
                if data {
                    self.listComment.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .bottom)
                } else {
                    
                }
            }
        }
    }
    
}
