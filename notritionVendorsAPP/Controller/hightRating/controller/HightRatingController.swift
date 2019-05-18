//
//  HightRatingController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import CCBottomRefreshControl
import GoogleMaps
import Firebase

class HightRatingController: UIViewController {

    // outlets
    @IBOutlet weak var itemCollection: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultSearchNotification: UILabel!
    @IBOutlet weak var searchBar: UIButton!
    
    // location manager
    var locationManager = CLLocationManager()
    var didUpdateLocation: Bool = false
    
    // variables
    var listItem = [ShopItemResponse] ()
    var currentListItem = [ShopItemResponse]()
    var listCategory = [CategoryResponse]()
    
    let headerId = "HeaderID"
    var categoryId = 0
    private var lastContentOffset: CGFloat = 0
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = APP_COLOR
        refreshControl.addTarget(self, action: #selector(loadMoreData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebase()
//        setupCurrentLocation()
//        setUpCollectionView()
//        registerHeader()
//
//        resultSearchNotification.isHidden = true
//        activityIndicator.color = APP_COLOR
//        activityIndicator.startAnimating()
//
//        navigationController?.navigationBar.barTintColor = APP_COLOR
//        findAllCategory()
//        loadDataFromAPI(offset: 0)
    }
    
    func setupCurrentLocation() {
        
        // User Location
        locationManager.delegate = self
        
        // Start Location
        accessLocationServices()
    }
    
    func registerHeader() {
        itemCollection.register(UINib(nibName: CellClassName.category.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.category.rawValue)

    }
    
    func setUpCollectionView() {
        itemCollection.delegate = self
        itemCollection.dataSource = self
        itemCollection.bottomRefreshControl = refresher
        
        searchBar.adjustsImageWhenHighlighted = false
    }
    
    func findAllCategory() {
        CategoryService.shared.findAll() { data in
            guard let data = data else {return }
            
            self.listCategory = data
        }
    }
    
    func loadDataFromAPI(offset: Int) {
        ShopItemService.shared.getHighRatingItem(offset: offset) { data in
            guard let data = data else {return }
            
            for item in data {
                self.listItem.append(item)
            }
            self.currentListItem = self.listItem
            self.activityIndicator.stopAnimating()
            self.itemCollection.reloadData()
        }
    }
    
    @objc
    func loadMoreData() {
        loadDataFromAPI(offset: listItem.count)
        refresher.endRefreshing()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewItemController {
            let vc = segue.destination as? ViewItemController
            let index = sender as! Int
            vc?.item = currentListItem[index]
            
        } else if segue.destination is SearchController {
            _ = segue.destination as? SearchController
//            vc?.listItem = currentListItem
            
        } else if segue.destination is CategoryController {
            let vc = segue.destination as? CategoryController
            let index = sender as! Int
            vc?.categoryId = listCategory[index].id!
            vc?.categoryName = listCategory[index].name!
        }
    }
    
    // MARK - Map, Location
    
    func startUpdateLocation() {
        didUpdateLocation = false
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        didUpdateLocation = true
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifier.highRatingToSearch.rawValue, sender: nil)
    }
}

extension HightRatingController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? listCategory.count : currentListItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.category.rawValue, for: indexPath) as! CategoryCell
                cell.updateView(Category: listCategory[indexPath.row])
                return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.highRatingItem.rawValue, for: indexPath) as! CollectionItemCell
            cell.updateView(shopItemRe: currentListItem[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            performSegue(withIdentifier: SegueIdentifier.highRatingToCategory.rawValue, sender: indexPath.row)
        } else {
            performSegue(withIdentifier: SegueIdentifier.highRatingToDetail.rawValue, sender: indexPath.row)
        }
    }
}


extension HightRatingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let cellWidth = (UIScreen.main.bounds.size.width - 50)/3
            return CGSize(width: cellWidth, height: 90)
        } else {
            let cellWidth = (UIScreen.main.bounds.size.width - 30)/2
            return CGSize(width: cellWidth, height: 175)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderCollectionCell
        if indexPath.section == 0 {
            headerView.updateView(titleStr: "Categories")
        } else {
            
            headerView.updateView(titleStr: "Foods")
        }
        
       return headerView
  }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
}

extension HightRatingController: CLLocationManagerDelegate {
    
    func handleDidUpdateLocation(location: CLLocation) {
        guard !didUpdateLocation else {
            stopUpdateLocation()
            return
        }
        
        stopUpdateLocation()
        AuthServices.instance.currentLocation = location
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        handleDidUpdateLocation(location: location)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}

extension HightRatingController : LocationServicesProtocol {
    func authorizedLocationServices() {
        startUpdateLocation()
    }
}


extension HightRatingController {
    
    func saveiamge() {
        let db = Firestore.firestore()
        let docRef = db.collection("shop_item")
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                print(document.documents)
                var shopList = [ShopItemResponseFB]()
                for shopDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: shopDoct.data() as Any)
                    do {
                        var shop = try JSONDecoder().decode(ShopItemResponseFB.self, from: jsonData!)
                        shop.id = shopDoct.documentID
                        shopList.append(shop)
                    
                        
                        let usrl = BASE_URL + "document/\(shop.oldid!)"
                        NetworkingClient.shared.requestJson(urlStr: usrl, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
                            guard let data = data else {return}
                            do {
                                var avat = ""
                                var images = [String]()
                                let items = try JSONDecoder().decode([Document].self, from: data)
                                for item in items {
                                    if item.priority == 1 {
                                        avat = item.link
                                    }
                                    images.append(item.link)
                                    
                                    let u = BASE_URL_IMAGE + item.link
                                    guard let urls = URL(string: u) else { return }
                                    URLSession.shared.dataTask(with: urls, completionHandler: { (data, respones, error) in
                                        
                                        if error != nil {
                                            print(error ?? "")
                                            return
                                        }
                                        
                                    
                                        DispatchQueue.main.async {
                                            guard let data = data else { return }
                                            guard let imageToCache = UIImage(data: data) else { return }
                                            
                                            ImageFirebase.instance.up
                                        }
                                        
                                    }).resume()
                                }
                                
                                let db = Firestore.firestore()
                                
                                let values = ["avatar": avat,
                                              "images": images] as [String : Any]
                                
                                db.collection("shop_item").document(shop.id!).updateData(values) { err in
                                    var result = true
                                    if let err = err {
                                        result = false
                                        print("Error writing document: \(err)")
                                    } else {
                                        print("Document successfully written!")
                                    }
                                }
                                
                            }catch let err {
                                
                            }
                            
                        }
                        
                        
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }

            } else {
                print("User have no profile")
            }
        })
    }
    
    func firebase() {
        
        let urlStr = BASE_URL + "shop/offset/0"
        print(urlStr)
        //
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let items = try JSONDecoder().decode([ShopResponse].self, from: data)
                for item in items {
                    print("run")
                    let key = String.gennerateKeywords([item.name ?? "", item.location?.address ?? ""])
                    let db = Firestore.firestore()
                    let shop = [
                        "oldid": item.id as Any,
                        "address": item.location?.address as Any,
                        "avatar": "",
                        "create_date": Date().timeIntervalSince1970,
                        "keyword" : key,
                        "latitude": item.location?.latitude,
                        "longitude": item.location?.longitude,
                        "name":  item.name,
                        "phone": item.phone,
                        "rating" : item.rating,
                        "sell" : "",
                        "status" : 1,
                        "time_close" : item.time_open,
                        "time_open": item.time_close,
                        "user_id" : "HWQ9thTlZMVmnKWgb5C5UP9Re0r1"
                        ] as [String : Any]
                    

                    
                    var ref: DocumentReference? = nil
                    
                    // init first to get ID
                    ref = db.collection("shop").document()
                    
                    ref?.setData(shop, completion:{ (error) in
                        if error != nil {
                            return
                        }
                        print("save shop")
                        let shopId = ref?.documentID
                        
                        let urlStr = BASE_URL + "shop-item/shop/\(item.id!)/0"
                        // 
                        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
                            
                            guard let data = data else {return}
                            do {
                                
                                let iss = try JSONDecoder().decode([ShopItemResponse].self, from: data)
                                for i in iss {
                                    
                                    print("running")
                                    let docRef = db.collection("item").whereField("name", isEqualTo: i.name!)
                                    //            .order(by: "update_date", descending: true)
                                    print("aaaa")
                                    docRef.getDocuments(completion: { (document, error) in
                                        if let document = document {
                                            
                                            for cmtDoct in document.documents{
                                                print("get item")
                                                
                                                let jsonData = try? JSONSerialization.data(withJSONObject: cmtDoct.data() as Any)
                                                
                                                do {
                                                    let cmt = try JSONDecoder().decode(Cate.self, from: jsonData!)
                                                    let aaaa = cmtDoct.documentID
                                                    
                                                    let key = String.gennerateKeywords([i.name ?? "", i.address ?? "", i.shop_name ?? ""])
                                                    let s = ["name": i.name as Any,
                                                             "oldid": i.id as Any,
                                                                "avatar": i.avatar ?? "logo" as Any,
                                                                "comment_number": i.comment_number,
                                                                "favorites_number": i.favorites_number,
                                                                "create_date": Date().timeIntervalSince1970,
                                                                "rating": i.rating,
                                                                "shop_id": shopId as Any,
                                                                "shop_name": i.shop_name as Any,
                                                                "status": 1,
                                                                "unit": i.unit as Any,
                                                                "keywords": key as Any,
                                                                "item_id": aaaa as Any,
                                                                "images": "" as Any,
                                                                "latitude": item.location?.latitude,
                                                                "longitude": item.location?.longitude,
                                                                "price": i.price as Any] as [String : Any]
                                                    
                                                    // init first to get ID
                                                    db.collection("shop_item").document().setData(s, completion:{ (error) in
                                                        if error != nil {
                                                            return
                                                        }
                                                        print("save shop item")
                                                    })
                                                    
                                                }catch let jsonError {
                                                    print("Error serializing json:", jsonError)
                                                }
                                            }
                                            
                                        } else {
                                            print("User have no comment")
                                        }
                                    })
                                    
                                    
                                }
                            } catch let err {}
                        }
                        
                    })
                }
            } catch let errs {
                
            }
        }
    }
    
    
//    func firebase() {
//
//        let urlStr = BASE_URL + "category"
//        //
//        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
//
//            guard let data = data else {return}
//            do {
//
//                let items = try JSONDecoder().decode([CategoryResponse].self, from: data)
//                for item in items {
//                    let db = Firestore.firestore()
//                    let shop = [
//                        "name": item.name as Any,
//                        "icon": item.icon] as [String : Any]
//
//                    var ref: DocumentReference? = nil
//
//                    // init first to get ID
//                    ref = db.collection("category").document()
//
//                    ref?.setData(shop, completion:{ (error) in
//                        if error != nil {
//                            return
//                        }
//                        print("save category")
//
//                        let urlStr = BASE_URL + "item/\(item.id!)"
//                        //
//                        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
//
//                            guard let data = data else {return}
//                            do {
//
//                                let iss = try JSONDecoder().decode([ItemResponse].self, from: data)
//                                for i in iss {
//                                    let db = Firestore.firestore()
//                                    let s = [
//                                        "category_id": ref?.documentID as Any,
//                                        "name": i.name as Any,
//                                        "unit": "kg"] as [String : Any]
//
//                                    var ref: DocumentReference? = nil
//
//                                    // init first to get ID
//                                    db.collection("item").document().setData(s, completion:{ (error) in
//                                        if error != nil {
//                                            return
//                                        }
//                                        print("save item")
//                                    })
//                                }
//                            } catch let err {}
//                        }
//
//                    })
//                }
//            } catch let errs {
//
//            }
//        }
//    }
}
        
        
//        let db = Firestore.firestore()
//        let shop = [
//            "id": item.id as Any,
//            "category_id": id as Any,
//            "name": item.name as Any,
//            "unit": "kg" as Any] as [String : Any]
//
//        var ref: DocumentReference? = nil
//
//        // init first to get ID
//        ref = db.collection("item").document()
//
//        ref?.setData(shop, completion:{ (error) in
//            DispatchQueue.main.async {
//                completion(ref?.documentID, true)
//            }
//
//        })
        
//        let urlStr = BASE_URL + "item"
//
//    NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
//
//        guard let data = data else {return}
//        do {
//
//            let items = try JSONDecoder().decode([ItemResponse].self, from: data)
//                for item in items {
//
//                    print("add suceess")
//                    var id = ""
//                    for i in AuthServices.instance.cate {
//                        if i.olid == item.category?.id {
//                            id = i.id!
//                        }
//                    }
//
//                    ItemFirebase.instance.addOne(item: item, id: id, completion: { (id, check) in
//                        print("add suceess")
//                        AuthServices.instance.listitem.append(ItemF(oldid: item.id!, id: id! ))
//                    })
//                }
//
        
//
                
//                ShopServices.shared.getNewestShop(offset: 0) { (data) in
//                    let shops = data!
//
//                    for shop in shops {
//                        let keys = String.gennerateKeywords([shop.name!, (shop.location?.address!)!])
//                        ShopFirebase.instance.addNewShop(shop: shop, keyword: keys, completion: { (id, check) in
//                            listI.append(ShopF(oldid: shop.id ?? 0, id: id ?? ""))
//                        })
//                    }
//                }
//
//                ShopItemService.shared.getHighRatingItem(offset: 0, completion: { (data) in
//                    let items = data!
//
//                    for i in items {
//                        let key = String.gennerateKeywords([i.name!, i.address!, i.shop_name!])
//                        var shopid = ""
//                        for j in listI {
//                            if i.id == j.olid {
//                                shopid = j.id ?? ""
//                            }
//                        }
//
//                        var itemid = ""
//                        for j in listitem {
//                            if i.id == j.olid {
//                                itemid = j.id ?? ""
//                            }
//                        }
//
//                        ShopItemFirebase.instance.addOne(item: i, shopid: shopid, key: key, itemid: itemid, completion: { (data) in
//
//                        })
//                    }
//                })
                
        
class ItemF : Decodable {
    var olid: Int?
    var id: String?
    
    init(oldid: Int, id: String) {
        self.olid = oldid
        self.id = id
    }
    
    convenience init() {
        self.init(oldid: 0, id: "")
    }
}

class ShopF: Decodable {
    var olid: Int?
    var id: String?
    
    init(oldid: Int, id: String) {
        self.olid = oldid
        self.id = id
    }
    
    convenience init() {
        self.init(oldid: 0, id: "")
    }
}

class Cate : Decodable {
    var name: String?
    var id: String?
    var category_id: String
    
    init(name: String, id: String, category_id: String) {
        self.name = name
        self.id = id
        self.category_id = category_id
    }
    
    convenience init() {
        self.init(name: "", id: "", category_id: "")
    }
}
