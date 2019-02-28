//
//  ViewItemController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/28/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ViewItemController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemComment: UITextField!
    @IBOutlet weak var itemPhotos: UITextField!
    @IBOutlet weak var itemFavorites: UITextField!
    @IBOutlet weak var itemRating: UITextField!
    @IBOutlet weak var genaralStackView: UIStackView!
    @IBOutlet weak var generalTableView: UITableView!
    
    var item = Item()
    var generalViewIcon = ["price-tag", "alarm-clock", "call", "placeholder", "catalog"]
    var generalViewValue = ["70.000 d", "7:00 - 21:00", "0969123456", "60 Ngo Sy Lien _ lien Chieu - Da Nang", "Fruits"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nho Den"
        setUpUI()
        viewDetailItem()
        setUPTableView()
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
        
        
        self.generalTableView.reloadData()
        generalTableView.estimatedRowHeight = UITableView.automaticDimension
        generalTableView.rowHeight = 40
    }
    
    func viewDetailItem() {
        itemName.text = "   " + "Nho Den"
        itemImage.image = UIImage(named: "secondBKImage")
        itemComment.text = "578"
        itemPhotos.text = "130"
        itemFavorites.text = "45"
        itemRating.text = "7.6"
    }
    

}

extension ViewItemController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralItemCell" ) as? GeneralItemCell{
//            cell.updateView(iconImage: generalViewIcon[indexPath.row], value: generalViewValue[indexPath.row])
            
            cell.imageView?.image = UIImage(named: generalViewIcon[indexPath.row])
            cell.label.text = "           "  + generalViewValue[indexPath.row]
//            cell.label.text =  generalViewValue[indexPath.row]
            cell.label.sizeToFit()
            cell.label.textAlignment = NSTextAlignment.center
            
            return cell
        }
        
        return GeneralItemCell()
    }
    
    
}
