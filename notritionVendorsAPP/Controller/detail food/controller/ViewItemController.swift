//
//  ViewItemController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Firebase
import PKHUD


class ViewItemController: UIViewController {
    
    @IBOutlet weak var tabelView: UITableView!
    
    // variables
    var comments = [CommentResponse]()
    var itemValues = [ItemValue] ()
    var item = ShopItemResponse()
    var loveBtn = UIButton()
    var rating = UITextField()
    var numberComment = UITextField()
    var numberFavorites = UITextField()
    var isRefersh = false
    var shouldReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibCell()
        
        self.title = item.name!
        navigationController?.navigationBar.barTintColor = APP_COLOR
        prepareData()
        saveAsRecent()
        tabelView.tableFooterView = UIView()
    }
    
    func saveAsRecent(){
        AuthServices.instance.checkLogedIn { (data) in
            guard let data = data else { return }
            
            if data {
                RecentService.instance.saveOne(shopItem: self.item)
            }
        }
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
    
    
    func updateComment(offset: Int) {
        HUD.show(.progress)
        
        CommentServices.instance.getCommentsByShopItem(shopItemID: item.id ?? "") { (data) in
            guard let data = data else {return }
            
            HUD.hide()
            self.comments = data
            self.tabelView.reloadData()
        }
    }
    
    func getShopItem() {
        HUD.show(.progress)
        
        ShopItemService.instance.getOneById(shop_item_id: item.id ?? "") { (data) in
            guard let data = data else { return }
            
            HUD.hide()
            self.shouldReload = false
            self.item = data
            self.tabelView.reloadData()
        }
    }
    
    func prepareData() {
        let price = "VND " + (item.price?.formatPrice())! + "/\(item.unit!)"
        appendItemValue(icon: Icon.price_icon.rawValue, value: price )
        appendItemValue(icon: Icon.time_icon.rawValue, value: (item.time_open ?? ""  ) + " - " + (item.time_close ?? ""))
//        appendItemValue(icon: Icon.category_icon.rawValue, value: "Rau cu")
        appendItemValue(icon: Icon.shop_icon.rawValue, value: (item.shop_name ?? "" ))
        appendItemValue(icon: Icon.picture.rawValue, value: "\(item.images?.count ?? 0) photos")
//        appendItemValue(icon: Icon.address_icon.rawValue, value: (item.shop!.location!.address!  ))
        appendItemValue(icon: Icon.phone_icon.rawValue, value: (item.phone ?? "" ))
        
        setUPTableView()
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
            vc?.currentShop = ShopResponse(name: item.shop_name ?? "", address: item.address ?? "", longitude: item.longitude ?? 0, latitude: item.latitude ?? 0)
            vc?.isFromShop = false
            
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is PhotoItemController {
            let vc = segue.destination as? PhotoItemController
            vc?.images = item.images ?? []
            
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is LoginController {
            _ = segue.destination as? LoginController
            
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is ItemInShopController {
            let vc = segue.destination as? ItemInShopController
            vc?.shop = ShopResponse(id: item.shop_id ?? "", name: item.shop_name ?? "")
            vc?.isFromFood = true
            
            navigationItem.backBarButtonItem = backItem
            
        } else if  segue.destination is DeliveryController {
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is NewCommentController {
            let vc = segue.destination as? NewCommentController
            vc?.shopItem = item
            navigationItem.backBarButtonItem = backItem
        } else if segue.destination is ChatController {
            let vc = segue.destination as? ChatController
            vc?.shop = ShopResponse(id: item.shop_id ?? "", name: item.shop_name ?? "")
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
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                HUD.show(.success)
                
                FavoritesService.instance.loveOne(shopItem: self.item, completion: { (status, success) in
                    guard let status = status else { return }
                    var loveIconName = ""
                    
                    if status == 0 {
                        self.numberFavorites.text = String(Int(self.numberFavorites.text!)! - 1)
                        loveIconName = "unlove"
                    } else {
                        self.numberFavorites.text = String(Int(self.numberFavorites.text!)! + 1)
                        loveIconName = "loved"
                    }
                    HUD.hide()
                    self.loveBtn.setImage(UIImage(named: loveIconName), for: .normal)
                })
            } else {
                // user is not signed in
                
                let alert = UIAlertController(title: "Can not love", message: "Please sign in!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.performSegueFunc(identifier: SegueIdentifier.detailFoodToLogin.rawValue)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc func viewMorePressed(btn: UIButton) {
        performSegueFunc(identifier: SegueIdentifier.detailToShop.rawValue)
    }
    
    
    @objc func deliveryPressed(btn: UIButton) {
        performSegueFunc(identifier: SegueIdentifier.detailToDelivery.rawValue)
    }
    
    @objc func chatBtnPressed(btn: UIButton) {
        performSegueFunc(identifier: SegueIdentifier.detailToChat.rawValue)
    }
    
    @objc func addCmtBtnPressed(btn: UIButton) {
        AuthServices.instance.checkLogedIn { (data) in
            guard let data = data else { return }
            
            if !data {
                // user is not signed in
                let alert = UIAlertController(title: "Can not Comment", message: "Please sign in!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.performSegueFunc(identifier: SegueIdentifier.detailFoodToLogin.rawValue)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else {
                self.shouldReload = true
                self.performSegueFunc(identifier: SegueIdentifier.detailToComment.rawValue)
            }
        }
    }
    
    @objc func mapPressedFunction() {
        
        print("touch on map")
    }
    
    
    
    override func dismissKeyboard() {
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
                 cell.updateView(item: item )
                return cell
            
            case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.actionCell.rawValue, for: indexPath) as! ActionCell


                    cell.viewMore.addTarget(self, action: #selector(viewMorePressed), for: UIControl.Event.touchDown)
                    cell.delivery.addTarget(self, action: #selector(deliveryPressed), for: UIControl.Event.touchDown)
                    cell.chatBtn.addTarget(self, action: #selector(chatBtnPressed), for: UIControl.Event.touchDown)

                    cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                    return cell
            
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.generalvalue.rawValue, for: indexPath) as! GeneralValueCell
                cell.updateView(icon_image: itemValues[indexPath.row].icon!, value: itemValues[indexPath.row].value!)
                
                if indexPath.row < 2 {
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
        if shouldReload {
            getShopItem()
        }
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
                case 2:
                    performSegueFunc(identifier: SegueIdentifier.detailToShop.rawValue)
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

