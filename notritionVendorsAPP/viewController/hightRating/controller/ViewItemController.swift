//
//  ViewItemController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ViewItemController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemComment: UITextField!
    @IBOutlet weak var itemPhotos: UITextField!
    @IBOutlet weak var itemFavorites: UITextField!
    @IBOutlet weak var itemRating: UITextField!
    @IBOutlet weak var genaralStackView: UIStackView!
    @IBOutlet weak var generalTableView: UITableView!
    @IBOutlet weak var commentTableView: UITableView!
    
    var item = Item()
    var generalViewIcon = ["price-tag", "alarm-clock", "call", "placeholder", "catalog"]
    var generalViewValue = ["70.000 d", "7:00 - 21:00", "0969123456", "60 Ngo Sy Lien _ lien Chieu - Da Nang", "Fruits"]
    var generals = [General(icon: "price-tag", value: "70.000 d")]
    
    struct General {
        let icon: String!
        let value: String!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        self.title = "Nho Den"
        setUpUI()
        viewDetailItem()
        setUPTableView()
    }
    
    func setUpScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 1500, right: 0)
        scrollView.delegate = self
    }
    
    func setUpUI() {
        itemName.setBottomBorder(color: UIColor.darkGray)
        itemName.setboldSystemFontOfSize(size: 25)
//        genaralStackView.addBottomBorder(color: UIColor.lightGray)
    }
    
    func setUPTableView() {
        generalTableView.delegate = self
        generalTableView.dataSource = self
        generalTableView.tableFooterView = UIView()
//        self.generalTableView.reloadData()
        generalTableView.estimatedRowHeight = UITableView.automaticDimension
        generalTableView.rowHeight = 40
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
//        commentTableView.tableFooterView = UIView()
//        commentTableView.estimatedRowHeight = UITableView.automaticDimension
//        commentTableView.rowHeight = 200
//
//        commentTableView.estimatedRowHeight = 200
//        commentTableView.rowHeight = UITableView.automaticDimension
    }
    
    func viewDetailItem() {
        itemName.text = "   " + "Nho Den"
        itemImage.image = UIImage(named: "secondBKImage")
        itemComment.text = "578"
        itemPhotos.text = "130"
        itemFavorites.text = "45"
        itemRating.text = "7.6"
    }
    
    var items: [User] = []

}

extension ViewItemController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == generalTableView {
            return items.count
        } else {
            return items.count
        }
        
        if section == 0 {
            return generalViewValue.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if  let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralItemCell" ) as? GeneralItemCell{
////            cell.updateView(iconImage: generalViewIcon[indexPath.row], value: generalViewValue[indexPath.row])
//
//            cell.imageView?.image = UIImage(named: generalViewIcon[indexPath.row])
//            cell.label.text = "           "  + generalViewValue[indexPath.row]
////            cell.label.text =  generalViewValue[indexPath.row]
//            cell.label.sizeToFit()
//            cell.label.textAlignment = NSTextAlignment.center
//
//            return cell
//        }
//
//        if  let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItem" ) as? CommentTableCell{
//
//            if indexPath.row == 4 {
//                let cellAdd = tableView.dequeueReusableCell(withIdentifier: "AddNewCMT") as? AddNewCommentCell
//
//                return cellAdd!
//            } else {
//
//                if indexPath.row % 2 == 0 {
//                    cell.updateView(userimage: "firstBKImage", username: "Tao Xanh", cmtDate: "20/02/2019", cmtTitle: "So good", rating: 4.5, cmtContent: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda")
//                }
//                else {
//                    cell.updateView(userimage: "firstBKImage", username: "Tao Xanh", cmtDate: "20/02/2019", cmtTitle: "So good", rating: 4.5, cmtContent: "It's good")
//                }
//
//                //
//                return cell
//            }
//
//        }
        
        if indexPath.section == 0 {
            let info = generals[indexPath.row]
            let value = info.value
        } else {
            
        }
        
        
        if tableView == generalTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralItemCell") as! GeneralItemCell
            //            cell.updateView(iconImage: generalViewIcon[indexPath.row], value: generalViewValue[indexPath.row])
            
            let user = items[indexPath.row]
            cell.updateView(iconImage: <#T##String#>, value: <#T##String#>)
            
            cell.imageView?.image = UIImage(named: generalViewIcon[indexPath.row])
            cell.label.text = "           "  + generalViewValue[indexPath.row]
            //            cell.label.text =  generalViewValue[indexPath.row]
            cell.label.sizeToFit()
            cell.label.textAlignment = NSTextAlignment.center
            
            
            return cell
        } else {
            if (indexPath.row == items.count - 1) {
                let cellAdd = tableView.dequeueReusableCell(withIdentifier: "AddNewCMT") as! AddNewCommentCell
                
                return cellAdd
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItem" ) as! CommentTableCell
                
                cell.updateView(userimage: "firstBKImage", username: "Tao Xanh", cmtDate: "20/02/2019", cmtTitle: "So good", rating: 4.5, cmtContent: "It's good")
                
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let addCmtCell = AddNewCommentCell()
        
        
//        commentTableView.tableFooterView = addCmtCell
        
        return addCmtCell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        commentTableView.estimatedRowHeight = 100
        commentTableView.rowHeight = UITableView.automaticDimension
    }
    
    
}

extension ViewItemController: UIScrollViewDelegate {
    
    private func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
        scrollView.isDirectionalLockEnabled = true
    }
    
}
