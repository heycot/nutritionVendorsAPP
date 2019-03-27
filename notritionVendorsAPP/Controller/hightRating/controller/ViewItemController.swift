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
        registerNibCell()
        self.title = item.name!
        navigationController?.navigationBar.barTintColor = APP_COLOR
        updateData()
        tabelView.tableFooterView = UIView()
        activityIndicatorView.startAnimating()
        
    }
    
    func registerNibCell() {
        
        //register nib cell file with className and identifier
        //register for generalInfor cell
        tabelView.register(UINib(nibName: CellClassName.generalInfor.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.generalInfor.rawValue)
        
        // register for generalValue cell
        tabelView.register(UINib(nibName: CellClassName.generalValue.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.generalvalue.rawValue)
        
        // register for listComment cell
        tabelView.register(UINib(nibName: CellClassName.listComment.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.listComment.rawValue)
        
        //register for add new comment cell
        tabelView.register(UINib(nibName: CellClassName.addNewComment.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.newComment.rawValue)
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

        switch section {
            case 0: return 1
            case 1: return itemValues.count
            case 2: return item.comments!.count
            default: return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.generalInfor.rawValue, for: indexPath) as! GeneralInforItemCell
                
                cell.updateView(item: item)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                return cell
            
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.generalvalue.rawValue, for: indexPath) as! GeneralValueCell
                cell.updateView(icon_image: itemValues[indexPath.row].icon!, value: itemValues[indexPath.row].value!)
                
                if indexPath.row < 3 {
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                }
                return cell
            
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.listComment.rawValue, for: indexPath) as! ViewCommentCell
                cell.updateView(comment: item.comments![indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                return cell
            
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newComment.rawValue, for: indexPath) as! AddNewCommentCell
                return cell
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabelView.estimatedRowHeight = 100
        tabelView.rowHeight = UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 4:
            return 0
        default:
            return 15.0
        }
//        return 15.0
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



