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
    var comments = [CommentResponse]()
    var itemValues = [ItemValue] ()
    var item = ShopItemResponse()
    var loveBtn = UIButton()
    var rating = UITextField()
    var numberComment = UITextField()
    var numberFavorites = UITextField()
    var isRefersh = false
    
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
        
        // register for map cell
        tabelView.register(UINib(nibName: CellClassName.mapCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.mapCell.rawValue)
        
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
            
            
            self.item.documents = data.documents
            self.item.shop = data.shop
            self.item.shop?.location = data.shop?.location
            
//            self.item.distance = ShopServices.shared.getDistance(shop: self.item.shop ?? ShopResponse(), currlocation: AuthServices.instance.currentLocation)
            
            self.prepareData()
        }
    }
    
    func updateComment(offset: Int) {
        CommentServices.shared.getComments(shopitemId: item.id!, offset: offset) { data in
            guard let data = data else {return }
            
            self.comments = data
            self.tabelView.reloadData()
        }
    }
    
    func prepareData() {
        appendItemValue(icon: Icon.price_icon.rawValue, value: "VND \(item.price!)")
        appendItemValue(icon: Icon.time_icon.rawValue, value: (item.shop!.time_open!  ) + " - " + (item.shop!.time_close!))
//        appendItemValue(icon: Icon.category_icon.rawValue, value: "Rau cu")
        appendItemValue(icon: Icon.shop_icon.rawValue, value: (item.shop!.name!  ))
        appendItemValue(icon: Icon.picture.rawValue, value: String(item.documents!.count) + " photos")
//        appendItemValue(icon: Icon.address_icon.rawValue, value: (item.shop!.location!.address!  ))
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
            vc?.currentShop = item.shop!
            vc?.isFromShop = false
            
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is PhotoItemController {
            let vc = segue.destination as? PhotoItemController
            vc?.documents = item.documents!
            
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is LoginController {
            _ = segue.destination as? LoginController
            
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is ItemInShopController {
            let vc = segue.destination as? ItemInShopController
            vc?.shop = item.shop!
            
            navigationItem.backBarButtonItem = backItem
            
        } else if  segue.destination is DeliveryController {
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is NewCommentController {
            let vc = segue.destination as? NewCommentController
            vc?.nameShop = item.name! + " - " + (item.shop?.name!)!
            vc?.addressShop = item.address!
            vc?.shopitemId = item.id!
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    public func performSegueFunc(identifier: String ) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: self)
        }
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
        performSegueFunc(identifier: SegueIdentifier.detailToShop.rawValue)
    }
    
    
    @objc func deliveryPressed(btn: UIButton) {
        performSegueFunc(identifier: SegueIdentifier.detailToDelivery.rawValue)
    }
    
    @objc func addCmtBtnPressed(btn: UIButton) {
        if !AuthServices.instance.isLoggedIn {
            let alert = UIAlertController(title: "Can not Comment", message: "Please sign in!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.performSegueFunc(identifier: SegueIdentifier.detailFoodToLogin.rawValue)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            performSegueFunc(identifier: SegueIdentifier.detailToComment.rawValue)
        }
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


extension ViewItemController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return itemValues.count
        case 4:
            return comments.count
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
                rating = cell.itemRating
                numberComment = cell.itemComments
                
                cell.updateView(item: item)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                return cell
            case 1:
                
                 let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.mapCell.rawValue, for: indexPath) as! MapCell
                cell.updateView(shop: item.shop!)
                return cell
            
            case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.actionCell.rawValue, for: indexPath) as! ActionCell


                    cell.viewMore.addTarget(self, action: #selector(viewMorePressed), for: UIControl.Event.touchDown)
                    cell.delivery.addTarget(self, action: #selector(deliveryPressed), for: UIControl.Event.touchDown)

                    cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                    return cell
            
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.generalvalue.rawValue, for: indexPath) as! GeneralValueCell
                cell.updateView(icon_image: itemValues[indexPath.row].icon!, value: itemValues[indexPath.row].value!)
                
                if indexPath.row < 3 {
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                    cell.accessoryView = UIView()
                }
                return cell
            
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.listComment.rawValue, for: indexPath) as! ViewCommentCell
                cell.updateView(comment: comments[indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                return cell
            
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.addCommentBtn.rawValue, for: indexPath) as! AddCommentBtnCell
                
                cell.addCmtBtn.addTarget(self, action: #selector(addCmtBtnPressed), for: UIControl.Event.touchDown)
                return cell
        }
        
    }
      
    
    override func viewWillAppear(_ animated: Bool) {
        tabelView.estimatedRowHeight = 100
        tabelView.rowHeight = UITableView.automaticDimension
        
        updateComment(offset: 0)
        super.viewWillAppear(true)
        tabelView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 4 ? 0.0 : 15.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegueFunc(identifier: SegueIdentifier.detailToLocation.rawValue)
            
        } else if indexPath.section == 3 {
            
            switch indexPath.row {
                case 3:
                    performSegueFunc(identifier: SegueIdentifier.detailFoodToPhoto.rawValue)
//                case 4:
//                    performSegueFunc(identifier: SegueIdentifier.detailToLocation.rawValue)
                default:
                    if true {
                        let phoneNumber = "033602512"
                        guard let url = URL(string: "telprompt://\(phoneNumber)")  else {  return }
                        
                        UIApplication.shared.canOpenURL(url)
                    }
            }
        } else if indexPath.section == 5 {
            performSegueFunc(identifier: SegueIdentifier.detailToComment.rawValue)
        }
    }
    
    
}

