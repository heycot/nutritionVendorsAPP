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
    var itemValues = [ItemValue] ()
    var item = ShopItemResponse()
    var loveBtn = UIButton()
    var numberFavorites = UITextField()
    
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
        
        //register for action celll
        tabelView.register(UINib(nibName: CellClassName.actionCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.actionCell.rawValue)
        
        // register for generalValue cell
        tabelView.register(UINib(nibName: CellClassName.generalValue.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.generalvalue.rawValue)
        
        // register for listComment cell
        tabelView.register(UINib(nibName: CellClassName.listComment.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.listComment.rawValue)
        
        //register for add new comment cell
        tabelView.register(UINib(nibName: CellClassName.addCommentBtn.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.addCommentBtn.rawValue)
    }
    
    func updateData() {
        ShopItemService.shared.getOneItem(id: item.id!) { data in
            guard let data = data else {return }
            
            self.item.comments = data.comments
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
        appendItemValue(icon: Icon.picture.rawValue, value: String(item.documents!.count) + " photos")
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
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        
        if segue.destination is ViewLocationShopController  {
            let vc = segue.destination as? ViewLocationShopController
            vc?.location = (item.shop?.location)!
            vc?.shopName = (item.shop?.name!)!
            
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is PhotoItemController {
            let vc = segue.destination as? PhotoItemController
            vc?.documents = item.documents!
            
            navigationItem.backBarButtonItem = backItem
        } else if segue.destination is LoginController {
            _ = segue.destination as? LoginController
            
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    public func performSegueFunc(identifier: String ) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    
    @objc func photoPressedFunction(textField: UITextField) {
        dismissKeyboard()
        performSegueFunc(identifier: SegueIdentifier.detailFoodToPhoto.rawValue)
    }
    
    @objc func lovePressedFunction(btn: UIButton) {
        
        if !AuthServices.instance.isLoggedIn {
            
            let alert = UIAlertController(title: "Can not love", message: "Please sign in!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.performSegueFunc(identifier: SegueIdentifier.detailFoodToLogin.rawValue)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            FavoritesService.shared.loveOne(shopItemId: item.id!) { data in
                guard let data = data else {return }
                var loveIconName = ""
                
                if data.status! == 0 {
                    self.numberFavorites.text = String(Int(self.numberFavorites.text!)! - 1)
                    loveIconName = "unlove"
                } else {
                    self.numberFavorites.text = String(Int(self.numberFavorites.text!)! + 1)
                    loveIconName = "loved"
                }
                self.loveBtn.setImage(UIImage(named: loveIconName), for: .normal)
            }
        }
    }
    
    @objc func viewMorePressed(btn: UIButton) {
        performSegueFunc(identifier: SegueIdentifier.detailFoodToPhoto.rawValue)
    }
    
    
    @objc func deliveryPressed(btn: UIButton) {
        performSegueFunc(identifier: SegueIdentifier.detailFoodToPhoto.rawValue)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


extension ViewItemController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return itemValues.count
        case 3:
            return (item.comments?.count)!
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.generalInfor.rawValue, for: indexPath) as! GeneralInforItemCell

                
                cell.itemPhotos.addTarget(self, action: #selector(photoPressedFunction), for: UIControl.Event.touchDown)
                cell.loveBtn.addTarget(self, action: #selector(lovePressedFunction), for: UIControl.Event.touchDown)
                loveBtn = cell.loveBtn
                numberFavorites = cell.itemFavorites
                
                cell.updateView(item: item)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                return cell
            
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.actionCell.rawValue, for: indexPath) as! ActionCell
                
                
                cell.viewMore.addTarget(self, action: #selector(viewMorePressed), for: UIControl.Event.touchDown)
                cell.delivery.addTarget(self, action: #selector(deliveryPressed), for: UIControl.Event.touchDown)
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                return cell
            
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.generalvalue.rawValue, for: indexPath) as! GeneralValueCell
                cell.updateView(icon_image: itemValues[indexPath.row].icon!, value: itemValues[indexPath.row].value!)
                
                if indexPath.row < 3 {
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                    cell.accessoryView = UIView()
                }
                return cell
            
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.listComment.rawValue, for: indexPath) as! ViewCommentCell
                cell.updateView(comment: item.comments![indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                return cell
            
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.addCommentBtn.rawValue, for: indexPath) as! AddCommentBtnCell
                return cell
        }
        
    }
      
    
    override func viewWillAppear(_ animated: Bool) {
        tabelView.estimatedRowHeight = 100
        tabelView.rowHeight = UITableView.automaticDimension
        
        super.viewWillAppear(true)
        tabelView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 3 ? 0.0 : 15.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            switch indexPath.row {
                case 3:
                    performSegueFunc(identifier: SegueIdentifier.detailFoodToPhoto.rawValue)
                case 4:
                    performSegueFunc(identifier: SegueIdentifier.detailToLocation.rawValue)
                default:
                    if true {
                        let phoneNumber = "033602512"
                        guard let url = URL(string: "telprompt://\(phoneNumber)")  else {  return }
                        
                        UIApplication.shared.canOpenURL(url)
                    }
            }
        }
    }
    
    
}

