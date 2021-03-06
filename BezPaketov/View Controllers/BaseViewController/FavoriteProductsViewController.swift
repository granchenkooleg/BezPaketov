//
//  FavoriteProductsViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 1/3/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteProductsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var internalProductsForListOfWeightVC = [Products]()
    var _productsList = [Products]()
    var basketHandler: Block? = nil
    
    var label: UILabel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize cell
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        spiner.hidesWhenStopped = true
        spiner.activityIndicatorViewStyle = .gray
        _ = view.add(spiner)
        spiner.center.x = view.center.x
        spiner.center.y = view.center.y - 150
        spiner.startAnimating()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _productsList = []
        tableView.reloadData()
        spiner.startAnimating()
        
        // Only isAuthorized user can see it VC
        guard  User.isAuthorized() else {
            self.spiner.stopAnimating()
            label = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 100))
            label?.text = "Только зарегистрированный пользователь может добавлять в избранные"
            label?.lineBreakMode = .byWordWrapping
            label?.numberOfLines = 0
            label?.center = CGPoint(x: CGFloat(view.frame.size.width / 2), y: CGFloat(150))
            label?.textAlignment = .center
            self.view.addSubview(label!)
            return
        }
        
        internalProductsForListOfWeightVC = []
        _productsList = []
        
        guard let id = User.currentUser?.idUser else {return}
        
        func favoritOfProducts(_ completion: @escaping Block)  {
            let param: Dictionary = ["salt": "d790dk8b82013321ef2ddf1dnu592b79",
                                     "user_id" : Int(id) as! AnyHashable] as [String : Any]
            
            UserRequest.favorite(param as [String : AnyObject], completion: {[weak self] json in
                json.forEach { _, json in
                    guard (json.isEmpty) == false else {return}
                    let valuesUnitForWeightAfterRework = String(describing: json["values"][0]["unit"])
                    let valuesValueForWeightAfterRework = String(describing: json["values"][0]["value"])
                    let id = json["id"].string ?? ""
                    let created_at = json["created_at"].string ?? ""
                    let icon = json["icon"].string ?? ""
                    let name = json["name"].string ?? ""
                    let category_id = json["category_id"].string ?? ""
                    let weight = json["weight"].string ?? ""
                    let description = json["description"].string ?? ""
                    let brand = json["brand"].string ?? ""
                    let calories = json["calories"].string ?? ""
                    let proteins = json["proteins"].string ?? ""
                    let zhiry = json["zhiry"].string ?? ""
                    let uglevody = json["uglevody"].string ?? ""
                    let price = json["price"].string ?? ""
                    let favorite = json["favorite"].string ?? ""
                    let status = json["status"].string ?? ""
                    let expire_date = json["expire_date"].string ?? ""
                    let category_name = json["category_name"].string ?? ""
                    let price_sale = json["price_sale"].string ?? ""
                    var units = json["units"].string ?? ""
                    if units == "kg" {
                        units = "кг."
                    }
                    if units == "liter" {
                        units = "л."
                    }
                    let image = Data()
                    if icon.isEmpty == false {
                        
                        let list = Products(valuesUnitForWeightAfterRework: valuesUnitForWeightAfterRework, valuesValueForWeightAfterRework: valuesValueForWeightAfterRework, id: id, description: description, proteins: proteins, calories: calories, zhiry: zhiry, favorite: favorite, category_id: category_id, brand: brand, price_sale: price_sale, weight: weight, status: status, expire_date: expire_date, price: price, created_at: created_at, icon: icon, category_name: category_name, name: name, uglevody: uglevody, units: units, image: image)
                        self?.internalProductsForListOfWeightVC.append(list)
                    }
                }
                
                self?._productsList = (self?.internalProductsForListOfWeightVC)!
                self?.spiner.stopAnimating()
                self?.tableView.reloadData()
            })
        }
        
        // Check Internet connection
        guard isNetworkReachable() == true  else {
            
            Dispatch.mainQueue.async {
                print("Internet connection FAILED")
                let alert = UIAlertController(title: "Нет Интернет Соединения", message: "Убедитесь, что Ваш девайс подключен к сети интернет", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "Ok", style: .default) {action in
                    guard isNetworkReachable() == true else {
                        self.present(alert, animated: true)
                        return }
                    // Call function
                    favoritOfProducts({})
                }
                alert.addAction(OkAction)
                alert.show()
            }
            return
        }
        
        // Call function
        favoritOfProducts({})
    }
    
    // For dynamic height cell
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        label?.removeFromSuperview()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FavoriteProductsViewController"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavoriteProductsTableViewCell
        
        let productDetails = _productsList[indexPath.row]
        
        // For + and - so that they here correspond self values and don't will overwritten values of another cell
        var quantityForRealm = 0
        var quantityWeighInitial: Int? = 0
        
        // Here i think will be шт and value will be always
        if productDetails.valuesValueForWeightAfterRework.isEmpty != true {
            quantityForRealm = Int(productDetails.valuesValueForWeightAfterRework) ?? 0
            quantityWeighInitial = Int(productDetails.valuesValueForWeightAfterRework) ?? 0
        }
        
        // Button action
        cell.buttomAddAction = { /*[weak self]*/ (sender) in
            if productDetails.valuesUnitForWeightAfterRework != "шт"
            {
                quantityForRealm += quantityWeighInitial ?? 0
                // For short entry
                if quantityForRealm >= 1000 && productDetails.valuesUnitForWeightAfterRework == "гр" {
                    cell.quantityLabel?.text = "\(Double(quantityForRealm) / 1000)" + " кг"
                } else {
                    cell.quantityLabel?.text = "\(quantityForRealm)" + " \(productDetails.valuesUnitForWeightAfterRework)"
                }
            } else {
                quantityForRealm += Int(productDetails.valuesValueForWeightAfterRework) ?? 0
                cell.quantityLabel.text = "\(quantityForRealm )" + " \(productDetails.valuesUnitForWeightAfterRework)  "
            }
            
        }
        
        cell.buttonSubAction = { /*[weak self]*/ (sender) in
            if productDetails.valuesUnitForWeightAfterRework != "шт" {
                guard quantityForRealm > (quantityWeighInitial ?? 0) else { return }
                quantityForRealm -= quantityWeighInitial ?? 0
                // For short entry
                if quantityForRealm >= 1000 {
                    cell.quantityLabel?.text = "\(Double(quantityForRealm) / 1000)" + " кг"
                } else {
                    cell.quantityLabel?.text = "\(quantityForRealm)" + " \(productDetails.valuesUnitForWeightAfterRework)"
                }
            } else {
                guard quantityForRealm > 1 else { return }
                quantityForRealm -= Int(productDetails.valuesValueForWeightAfterRework) ?? 0
                cell.quantityLabel.text = "\(quantityForRealm)" + " \(productDetails.valuesUnitForWeightAfterRework)  "
            }
            
        }
        
        cell.buttonAction = {[weak self] (sender) in
            
            // Do whatever you want from your button here.
            let realm = try! Realm()
            if let product = realm.objects(ProductsForRealm.self).filter("id  == [c] %@", productDetails.id ).first {
                try! realm.write {
                    product.weightAdd = "\((Int(???product.weightAdd) ?? 0) + quantityForRealm)"
                    
                    guard productDetails.valuesUnitForWeightAfterRework == "шт" else {return }
                    product.quantity = "\((Int(product.quantity) ?? 0) + quantityForRealm)"
                }
            } else {
                let image: Data? = nil
                
                let _ = ProductsForRealm.setupProduct(id: productDetails.id , descriptionForProduct: productDetails.description , proteins: productDetails.proteins , calories: productDetails.calories , zhiry: productDetails.zhiry , favorite: "", category_id: "", brand: productDetails.brand , price_sale: productDetails.price_sale , weight: productDetails.valuesValueForWeightAfterRework, weightAdd: "\(quantityForRealm)", status: "", expire_date: productDetails.expire_date , price: productDetails.price , created_at: productDetails.created_at , icon: productDetails.icon , category_name: "", name: productDetails.name , uglevody: productDetails.uglevody , units: productDetails.valuesUnitForWeightAfterRework, quantity: "\(quantityForRealm)", image: image)
            }
            
            let alert = UIAlertController(title: "Товар добавлен в пакет", message: "", preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "Ok", style: .default) {action in
                // Reset
                quantityForRealm = Int(productDetails.valuesValueForWeightAfterRework) ?? 0
                cell.quantityLabel.text = "\(quantityForRealm)" + " \(productDetails.valuesUnitForWeightAfterRework)  "
            }
            alert.addAction(OkAction)
            alert.show()
            
            self?.basketHandler?()
        }
        
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.sd_setImage(with: URL(string: (productDetails.icon)))
        }
        
        cell.nameLabel?.text = productDetails.name
        cell.descriptionLabel?.text = productDetails.description
        cell.weightLabel?.text = productDetails.valuesValueForWeightAfterRework  + " \(_productsList[indexPath.row].valuesUnitForWeightAfterRework)."
        cell.priceOldLabel?.text = productDetails.price + " грн. /"
        
        // For display values in label
        if productDetails.valuesUnitForWeightAfterRework != "гр" {
            cell.quantityLabel?.text = "\(quantityForRealm)" + " \(productDetails.valuesUnitForWeightAfterRework)   "
        } else {
            if quantityForRealm >= 1000 && productDetails.valuesUnitForWeightAfterRework == "гр" {
                cell.quantityLabel?.text = "\(Double(quantityForRealm) / 1000)" + " кг"
            } else {
                cell.quantityLabel?.text = "\(quantityForRealm)" + " \(productDetails.valuesUnitForWeightAfterRework)"
            }
        }
        
        //if price_sale != 0.00 грн, set it
        if productDetails.price_sale != "0.00" {
            cell.priceSaleLabel?.text = "  " + productDetails.price_sale +  " грн. /"
            
            // Create attributed string for strikethroughStyleAttributeName
            let myString = productDetails.price + " грн."
            let myAttribute = [ NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            
            // Set attributed text on a UILabel
            cell.priceOldLabel?.attributedText = myAttrString
        } else {
            cell.priceSaleLabel?.text = ""
        }
        
        return cell
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Check Internet connection
        guard isNetworkReachable() == true  else {
            Dispatch.mainQueue.async {
                let alert = UIAlertController(title: "Нет Интернет Соединения", message: "Убедитесь, что Ваш девайс подключен к сети интернет", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "Ok", style: .default) {action in
                    
                }
                alert.addAction(OkAction)
                alert.show()
            }
            return
        }
        
        detailsVC (indexPath: indexPath)
    }
    
    func detailsVC (indexPath: IndexPath) {
        let detailsProductVC = Storyboard.DetailsProduct.instantiate()
        //detailsProductVC.weightDetailsVC = _productsList[indexPath.row].weight + " \(_productsList[indexPath.row].units)"
        detailsProductVC.weightValueDetailsVC = _productsList[indexPath.row].valuesValueForWeightAfterRework
        detailsProductVC.weightUnitDetailsVC = _productsList[indexPath.row].valuesUnitForWeightAfterRework
        detailsProductVC.categoryIdProductDetailsVC = _productsList[indexPath.row].category_id
        detailsProductVC.priceSaleDetailsVC = _productsList[indexPath.row].price_sale
        detailsProductVC.idProductDetailsVC = _productsList[indexPath.row].id
        detailsProductVC.priceDetailsVC = _productsList[indexPath.row].price
        detailsProductVC.descriptionDetailsVC = _productsList[indexPath.row].description
        detailsProductVC.uglevodyDetailsVC = _productsList[indexPath.row].uglevody
        detailsProductVC.zhiryDetailsVC = _productsList[indexPath.row].zhiry
        detailsProductVC.proteinsDetailsVC = _productsList[indexPath.row].proteins
        detailsProductVC.caloriesDetailsVC = _productsList[indexPath.row].calories
        detailsProductVC.expire_dateDetailsVC = _productsList[indexPath.row].expire_date
        detailsProductVC.brandDetailsVC = _productsList[indexPath.row].brand
        detailsProductVC.iconDetailsVC = _productsList[indexPath.row].icon
        detailsProductVC.created_atDetailsVC = _productsList[indexPath.row].created_at
        detailsProductVC.nameHeaderTextDetailsVC = _productsList[indexPath.row].name
        detailsProductVC.addToContainer()
    }
}

class FavoriteProductsTableViewCell: UITableViewCell {
    
    @IBOutlet var buttonCart: UIButton!
    var buttonAction: ((_ sender: AnyObject) -> Void)?
    @IBAction func buttonPressedCart(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
    }
    
    // For +
    @IBOutlet weak var addProductButton: UIButton!
    var buttomAddAction: ((_ sender: AnyObject) -> Void)?
    
    // For -
    @IBOutlet weak var subProductButton: UIButton!
    var buttonSubAction: ((_ sender: AnyObject) -> Void)?
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var priceOldLabel: UILabel!
    @IBOutlet weak var priceSaleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBAction func addProduct(sender: AnyObject) {
        self.buttomAddAction?(sender as AnyObject)
    }
    
    @IBAction func subProduct(sender: AnyObject) {
        self.buttonSubAction?(sender as AnyObject)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

