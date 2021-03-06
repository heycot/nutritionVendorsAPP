//
//  AccountController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Firebase
import YPImagePicker

class AccountDetailController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userAvatar: CustomImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var inforUser: UITextField!
    @IBOutlet weak var activitiesBtn: UIButton!
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var notification: UILabel!
    
    var titleCell = [   NSLocalizedString("Email:", comment: ""),
                        NSLocalizedString("Birthday:", comment: ""),
                        NSLocalizedString("Address:", comment: ""),
                        NSLocalizedString("Join on:", comment: ""),
                        NSLocalizedString("Edit information", comment: ""),
                        NSLocalizedString("Change password", comment: ""),
                        NSLocalizedString("", comment: "")]
    
    var detailCell = [String]()
    
    var user : UserResponse?
    var listComment = [CommentResponse]()
    var isActivity = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        disableUIView()
        
        
        setUpForTableView()
        notification.isHidden = true
    }
    
    func handleAfterLogOut() {
        userAvatar.image = UIImage(named: "logo")
        userAvatar.setBottomBorder(color: .white)
        username.text = NSLocalizedString("Guest", comment: "") 
        inforUser.text = NSLocalizedString("You are using this application as a guest", comment: "")
        notification.text = NSLocalizedString("No data to show", comment: "")
        notification.isHidden = false
        
        detailCell = [String]()
        
        for _ in 0 ..< 7 {
            detailCell.append("")
        }
        
        titleCell[titleCell.count - 1] = NSLocalizedString("Log in ", comment: "")
        listComment.removeAll()
        
        tableView.reloadData()
    }
    
    func getUser() {
        
        AuthServices.instance.checkLogedIn { (data) in
            guard let data = data else { return }
            
            if data {
                let userID = Auth.auth().currentUser?.uid
                AuthServices.instance.getProfile(userID: userID ?? "", completion: { (data) in
                    guard let data = data else { return }
                    self.user = data
                    self.getDataFromAPI(offset: 0, isLoadMore: false)
                    self.setupDetailInfor()
                })
            } else {
                self.handleAfterLogOut()
                self.notification.text = NSLocalizedString("No data to show", comment: "")
                self.notification.isHidden = false
            }
        }
    }
    
    func registerCells() {
        
        tableView.register(UINib(nibName: CellClassName.activityCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.activityCell.rawValue)
        
    }
    
    func viewInfor() {
        userAvatar.displayImage(folderPath: ReferenceImage.user.rawValue + "\(user?.avatar ?? "")")
        userAvatar.setRounded(color: .white)
        username.text = user?.name ?? ""
        inforUser.text = NSLocalizedString("newbee - Top 1000 - 10 Followers", comment: "")
        
        inforUser.setboldSystemFontOfSize(size: 14)
        username.setboldSystemFontOfSize(size: 18)
    }
    
    func setupDetailInfor() {
        
        titleCell[titleCell.count - 1] = NSLocalizedString("Log out ", comment: "")
        detailCell.removeAll()
        
        detailCell.append(user?.email ?? "")
        
        if (user?.birthday != nil) {
            let dateStr = NSObject().convertToString(date: user?.birthdayDate ?? Date() , dateformat: DateFormatType.date)
            detailCell.append(dateStr)
        } else {
            detailCell.append("")
        }
        
        let createDate = NSObject().convertToString(date: user?.createDate ?? Date(), dateformat: DateFormatType.date)
        
        detailCell.append(user?.address ?? "")
        detailCell.append(createDate)
        detailCell.append("")
        detailCell.append("")
        detailCell.append("")
        viewInfor()
        tableView.reloadData()
    }
    
    func setUpForTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func activitiesBtnPressed(_ sender: Any) {
        isActivity = true
        
        if listComment.count == 0 || user == nil {
            notification.text = NSLocalizedString("No data to show", comment: "")
            notification.isHidden = false
        } else {
            notification.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    @IBAction func accountBtnPressed(_ sender: Any) {
        isActivity = false
        
        if user == nil {
            notification.text = NSLocalizedString("No data to show", comment: "")
            notification.isHidden = false
        } else {
            notification.isHidden = true
        }
        
        
        tableView.reloadData()
    }
    
    
    func getDataFromAPI(offset: Int, isLoadMore: Bool) {
        
        CommentServices.instance.getAllCommentByUser { (data) in
            guard let data = data else { return }
            
            if data.count == 0 {
                self.notification.text = NSLocalizedString("No data to show", comment: "")
                self.notification.isHidden = false
            }
            
            self.listComment = data
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
            vc?.user = user ?? UserResponse()
        }
    }
    
    func updateAvatar(image: UIImage) {
        let fileName = String.generateNameForImage()
        let reference = ReferenceImage.user.rawValue + "\(fileName)"
        
        AuthServices.instance.updateAvatar(avatar: fileName, userID: self.user?.id ?? ""){ (data) in
            
        }
        ImageServices.instance.uploadMedia(image: image, reference: reference) { (data) in
            
        }
    }
    
    @IBAction func avatarBtnPressed(_ sender: Any) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
//        let picker = YPImagePicker()
//        picker.didFinishPicking { [unowned picker] items, _ in
//            if let photo = items.singlePhoto {
//
//                self.userAvatar.image = photo.image
//                self.userAvatar.setRounded(color: .white)
//                self.updateAvatar(image: photo.image)
//            }
//            picker.dismiss(animated: true, completion: nil)
//        }
//        present(picker, animated: true, completion: nil)
    }
}

extension AccountDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isActivity ? listComment.count : titleCell.count
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
        
        getUser()
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
                if user != nil {
                    self.user = nil
                    AuthServices.instance.signout()
                    self.handleAfterLogOut()
                } else {
                    self.performSegue(withIdentifier: "AccountToLogin", sender: nil)
                }
                
            } else if indexPath?.row ==  (index - 1) {
                performSegue(withIdentifier: SegueIdentifier.accountToPassword.rawValue, sender: nil)
            } else if indexPath?.row == ( index - 2){
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



extension AccountDetailController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        self.userAvatar.image = selectedImage
        self.userAvatar.setRounded(color: .white)
        self.updateAvatar(image: selectedImage)
        dismiss(animated: true, completion: nil)
        
    }
}
