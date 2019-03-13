//
//  ViewItemController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

enum CellClassName: String {
    case GeneralInfor   = "GeneralInforItemCell"
    case GeneralValue   = "GeneralValueCell"
    case ListComment    = "ViewCommentCell"
    case AddNewComment  = "AddNewCommentCell"
}

class ViewItemController: UIViewController {
    
    @IBOutlet weak var tabelView: UITableView!
    
    var comments = [Comment] ()
    var itemValues = [ItemValue] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nho Den"
        navigationController?.navigationBar.barTintColor = appColor
        prepareData()
        setUPTableView()
        prepareData()
    }
    
    func setUPTableView() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.tableFooterView = UIView()
    }
    
    func prepareData() {
        appendItemValue(icon: Icon.price_icon.rawValue, value: "VND 70.000")
        appendItemValue(icon: Icon.time_icon.rawValue, value: "10:00 - 21:00")
        appendItemValue(icon: Icon.phone_icon.rawValue, value: "0976514235")
        appendItemValue(icon: Icon.shop_icon.rawValue, value: "Shop Rau Sach")
        appendItemValue(icon: Icon.address_icon.rawValue, value: "60 Ngo Sy Lien")
        appendItemValue(icon: Icon.category_icon.rawValue, value: "Rau cu")
    }
    
    func appendItemValue(icon: String, value: String) {
        itemValues.append(ItemValue(icon: icon, value:  value))
    }
    
}







extension ViewItemController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        } else if section == 1{
            return 6
        } else if section == 2{
            return 6
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("section \(indexPath.section)")
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed(CellClassName.GeneralInfor.rawValue, owner: self, options: nil )?.first as! GeneralInforItemCell
            cell.updateView(image_name: "firstBKImage", item_name: "Nho Den", item_comment: 42, item_photo: 15, item_favorites: 50, item_rating: 4.5)
            return cell
        
        } else if indexPath.section == 1{
            let cell = Bundle.main.loadNibNamed(CellClassName.GeneralValue.rawValue, owner: self, options: nil )?.first as! GeneralValueCell
            cell.updateView(icon_image: itemValues[indexPath.row].icon, value: itemValues[indexPath.row].value)
            return cell

        } else if indexPath.section == 2{
            let cell = Bundle.main.loadNibNamed(CellClassName.ListComment.rawValue, owner: self, options: nil )?.first as! ViewCommentCell
            cell.updateView(user_image: "secondBKImage", user_name: "Callie", create_date: Date(), rating: 3.5, title: "Not good at all", content: "goscdsbcdcsdc")
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed(CellClassName.AddNewComment.rawValue, owner: self, options: nil )?.first as! AddNewCommentCell
            return cell
        }
    }
      
    
    override func viewWillAppear(_ animated: Bool) {
        tabelView.estimatedRowHeight = 100
        tabelView.rowHeight = UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.addObserver( self, selector: "keyboardWillShow:", name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    // Handle keyboard frame changes here.
    // Use the CGRect stored in the notification to determine what part of the screen the keyboard will cover.
    // Adjust our table view's contentInset and scrollIndicatorInsets properties so that the table view content avoids the part of the screen covered by the keyboard
    @objc func keyboardWillShow(_ tableView: UITableView, note:NSNotification )
    {
        // read the CGRect from the notification (if any)
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
    }
    
}


