//
//  ViewItemController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit


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
        appendItemValue(icon: Icon.category_icon.rawValue, value: "Rau cu")
        appendItemValue(icon: Icon.shop_icon.rawValue, value: "Shop Rau Sach")
        appendItemValue(icon: Icon.address_icon.rawValue, value: "60 Ngo Sy Lien")
        appendItemValue(icon: Icon.phone_icon.rawValue, value: "0976514235")
    }
    
    func appendItemValue(icon: String, value: String) {
        itemValues.append(ItemValue(icon: icon, value:  value))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewLocationShopController
        {
            let vc = segue.destination as? ViewLocationShopController
            vc?.address = "60 Ngo Sy Lien, Lien Chieu, Da nang, Viet Nam"
        }
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
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            return cell
        
        } else if indexPath.section == 1{
            let cell = Bundle.main.loadNibNamed(CellClassName.GeneralValue.rawValue, owner: self, options: nil )?.first as! GeneralValueCell
            cell.updateView(icon_image: itemValues[indexPath.row].icon, value: itemValues[indexPath.row].value)
            
            if indexPath.row <= 3 {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            }
            return cell

        } else if indexPath.section == 2{
            let cell = Bundle.main.loadNibNamed(CellClassName.ListComment.rawValue, owner: self, options: nil )?.first as! ViewCommentCell
            cell.updateView(user_image: "secondBKImage", user_name: "Callie", create_date: Date(), rating: 3.5, title: "Not good at all", content: "goscdsbcdcsdc")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
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
        if indexPath.section == 1 {
            if indexPath.row == 5  {
                
                if true {
                    let phoneNumber = "033602512"
                    guard let url = URL(string: "telprompt://\(phoneNumber)")  else {
                        return
                    }
                    
                    UIApplication.shared.canOpenURL(url)
                } 
                
            } else if indexPath.row == 6{
                
                self.performSegue(withIdentifier: "ShopLocationID", sender: self)
            }
        }
    }
    
    
}


