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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // variables
    var comments = [Comment] ()
    var itemValues = [ItemValue] ()
    var item = ShopItemResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = item.name!
        navigationController?.navigationBar.barTintColor = APP_COLOR
        updateData()
        tabelView.tableFooterView = UIView()
        activityIndicatorView.startAnimating()
    }
    
    func updateData() {
        ShopItemService.shared.getOneItem(id: item.id!) { data in
            guard let data = data else {return }
            
            self.item.comments = data.comments
//            self.comments = data.comments!
            self.item.documents = data.documents
            self.item.shop = data.shop
            self.item.shop?.location = data.shop?.location
            
            self.prepareData()
        }
    }
    
    func prepareData() {
        appendItemValue(icon: Icon.price_icon.rawValue, value: "VND \(item.price!)")
        appendItemValue(icon: Icon.time_icon.rawValue, value: (item.shop!.time_open!  ) + " - " + (item.shop!.time_close!))
//        appendItemValue(icon: Icon.category_icon.rawValue, value: "Rau cu")
        appendItemValue(icon: Icon.shop_icon.rawValue, value: (item.shop!.name!  ))
        appendItemValue(icon: Icon.address_icon.rawValue, value: (item.shop!.location!.address!  ))
        appendItemValue(icon: Icon.phone_icon.rawValue, value: (item.shop!.phone! ))
        
        setUPTableView()
        activityIndicatorView.stopAnimating()
        self.tabelView.reloadData()
    }
    
    
    func setUPTableView() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.tableFooterView = UIView()
    }
    
    
    func appendItemValue(icon: String, value: String) {
        itemValues.append(ItemValue(icon: icon, value:  value))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewLocationShopController
        {
            let vc = segue.destination as? ViewLocationShopController
            vc?.location = (item.shop?.location)!
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
            return itemValues.count
        } else if section == 2{
            return item.comments!.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed(CellClassName.GeneralInfor.rawValue, owner: self, options: nil )?.first as! GeneralInforItemCell
            
            cell.updateView(item: item)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            return cell
        
        } else if indexPath.section == 1{
            let cell = Bundle.main.loadNibNamed(CellClassName.GeneralValue.rawValue, owner: self, options: nil )?.first as! GeneralValueCell
            cell.updateView(icon_image: itemValues[indexPath.row].icon!, value: itemValues[indexPath.row].value!)
            
            if indexPath.row < 3 {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            }
            return cell

        } else if indexPath.section == 2{
            let cell = Bundle.main.loadNibNamed(CellClassName.ListComment.rawValue, owner: self, options: nil )?.first as! ViewCommentCell
            cell.updateView(comment: item.comments![indexPath.row])
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
            if indexPath.row == 4  {
                
                if true {
                    let phoneNumber = "033602512"
                    guard let url = URL(string: "telprompt://\(phoneNumber)")  else {
                        return
                    }
                    
                    UIApplication.shared.canOpenURL(url)
                } 
                
            } else if indexPath.row == 3{
                
                self.performSegue(withIdentifier: "ShopLocationID", sender: self)
            }
        }
    }
    
    
}


