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
import PKHUD

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
        saveiamge()
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
        HUD.flash(.success, delay: 1.5)
        CategoryService.instance.findAll { (data) in
            guard let data = data else { return }
            
            self.listCategory = data
            self.itemCollection.reloadData()
        }
    }
    
    func loadDataFromAPI(offset: Int) {
        
        ShopItemService.instance.getHighRatingItem(offset: offset) { data in
            guard let data = data else {return }
            
            for item in data {
                self.listItem.append(item)
            }
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
            vc?.item = listItem[index]
            
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
        return section == 0 ? listCategory.count : listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.category.rawValue, for: indexPath) as! CategoryCell
                cell.updateView(category: listCategory[indexPath.row])
                return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.highRatingItem.rawValue, for: indexPath) as! CollectionItemCell
            cell.updateView(shopItemRe: listItem[indexPath.row])
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
                                var ima = [UIImage]()
                                var images = [String]()
                                let items = try JSONDecoder().decode([Document].self, from: data)
                                for item in items {
                                    var filename = ""
                                    if item.priority == 1 {
                                        avat = item.link!
                                        images.append(avat)
                                        filename = avat
                                    } else {
                                        images.append(item.link!)
                                        filename = item.link!
                                    }
                                    
                                    let u = BASE_URL_IMAGE + item.link!
                                    guard let urls = URL(string: u) else { return }
                                    URLSession.shared.dataTask(with: urls, completionHandler: { (data, respones, error) in
                                        
                                        if error != nil {
                                            print(error ?? "")
                                            return
                                        }
                                        
                                        
                                        DispatchQueue.main.async {
                                            guard let data = data else { return }
                                            guard let imageToCache = UIImage(data: data) else { return }
                                            ima.append(imageToCache)
                                            
                                            
                                            let foler = ReferenceImage.shopItem.rawValue + shop.id! + "/\(filename)"
                                            
                                            ImageServices.instance.uploadMedia(image: imageToCache, reference: foler, completion: { (data) in
                                                print("save image success")
                                            })
                                            
                                        }
                                        
                                    }).resume()
                                }
                                
                                DispatchQueue.main.async {
                                    
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
                                }
                            } catch {}
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
}


class Document : Decodable {
    var id: Int?
    var link : String?
    var priority: Int?
}
