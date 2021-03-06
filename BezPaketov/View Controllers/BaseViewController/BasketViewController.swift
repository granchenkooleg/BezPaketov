//
//  BasketViewController.swift
//  Bezpaketov
//
//  Created by Oleg on 12/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import RealmSwift

class BasketViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        updateProductInfo()
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsInBasket.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BasketTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BasketTableViewCell
        
        
        let productDetails = productsInBasket[indexPath.row]
        Dispatch.mainQueue.async { _ in
            cell.thubnailImageView?.sd_setImage(with: URL(string: (productDetails.icon) ?? ""))
        }
        cell.productDetail = productDetails
        cell.descriptionLabel?.text = productDetails.descriptionForProduct
        
        // for cell----------
        cell.productID = productDetails.id
        cell.quantity = Int(productDetails.quantity) ?? 0
        //-------------------
        
        cell.nameLabel?.text = productDetails.name
        
        cell.weightLabel?.text = "\(productDetails.weight ?? "")" + " \(productDetails.units ?? "")."
        
        // Make a choice prices for to display prices
        if Double(productDetails.price_sale ?? "") ?? 0 > Double(0.00) {
            cell.priceLabel?.text = (productDetails.price_sale ?? "") + " грн. /"
        } else {
            cell.priceLabel?.text = (productDetails.price ?? "") + " грн. /"
        }
        
        if productDetails.units == "шт" {
            cell.quantityLabel?.text = productDetails.quantity  + " шт"
        } else {
            if (Int(productDetails.weightAdd ?? "") ?? 0) >= 1000 && (productDetails.units ?? "") == "гр" {
                cell.quantityLabel?.text = "\((Double(productDetails.weightAdd ?? "") ?? 0.0)  / 1000)" + " кг"
            } else {
                guard let quantity = productDetails.weightAdd else { return cell }
                cell.quantityLabel?.text = quantity + " \(productDetails.units!)"
            }
        }
        
        cell.completionBlock = {[weak self] in
            self?.updateProductInfo()
            self?.tableView.reloadData()
        }
        
        return cell
    }
    
    // Delete rows [start
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! productsInBasket.realm!.write {
                let product = self.productsInBasket[indexPath.row]
                self.productsInBasket.realm!.delete(product)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateProductInfo()
        }
    }
    //end]
    
    // Button delete red color
    @IBAction func deleteAllButton(_ sender: AnyObject) {
        
        // Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Удалить корзину?", message: "Вы на самом деле собираетесь удалить все продукты из корзины?", preferredStyle: .alert)
        
        // Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Нет", style: .cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        
        // Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Удалить", style: .destructive) {[weak self] action -> Void in
            //Do some other stuff
            ProductsForRealm.deleteAllProducts()
            
            self?.tableView.reloadData()
            self?.updateProductInfo()
        }
        actionSheetController.addAction(nextAction)
        
        // Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
        
        
    }
    
    // MARK: Sender to DrawingUpOfAnOrderVC
    @IBAction func DrawingUpOrderClick(_ sender: UIButton) {
        
        // Check empty basket for next step
        guard ((Double(totalPriceInCart())) != 0.0) else {
            let alertController = UIAlertController(title: "Ваш пакет пуст", message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                // ...
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
            
            return
        }
        
        // Check price value
        guard (Double(totalPriceInCart()))! >= (Double(300))  else {
            let alertController = UIAlertController(title: "Доставка на сумму до 300 грн. платная", message: "Стоимость доставки 30-50грн.", preferredStyle: .actionSheet)
            
            let buyMore = UIAlertAction(title: "Купить ещё", style: .default) { action -> Void in
                //Do some stuff
            }
            alertController.addAction(buyMore)
            self.present(alertController, animated: true)
            
            let nextAction = UIAlertAction(title: "Оформить заказ", style: .default) {action -> Void in
                let navToDrawUpOrder = UIStoryboard.main["drawingUpOrder"] as? DrawingUpOfAnOrderViewController
                navToDrawUpOrder?.addToContainer()
            }
            alertController.addAction(nextAction)
            
            return
        }
        
        let navToDrawUpOrder = UIStoryboard.main["drawingUpOrder"] as? DrawingUpOfAnOrderViewController
        navToDrawUpOrder?.addToContainer()
        
    }
    
    // MARK: Navigation and ClearDatabase for buttons in header BasketAfterPaymentVC and CheckVC [start
    @IBAction func basketClickAndClearDatabase(_ sender: AnyObject) {
        
        ProductsForRealm.deleteAllProducts()
        updateProductInfo()
        
        present(UIStoryboard.main["basket"]!, animated: true, completion: nil)
    }
    
    @IBAction func searchClickAndClearDatabase(_ sender: AnyObject) {
        
        ProductsForRealm.deleteAllProducts()
        updateProductInfo()
        
        present(UIStoryboard.main["search"]!, animated: true, completion: nil)
        
    }
    // end]
    
    
    
    
}

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    var productID: String = ""
    var quantity: Int = 0
    var completionBlock: Block?
    var productDetail: ProductsForRealm? = nil
    var xForWeight: Int = 0
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addProduct(sender: AnyObject) {
        if productDetail?.units == "шт" {
        quantity += 1
        } else {
        quantity += Int((productDetail?.weight) ?? "") ?? 0
        xForWeight = Int((productDetail?.weightAdd) ?? "") ?? 0
        xForWeight += Int((productDetail?.weight) ?? "") ?? 0
        }
        updateProduct()
        completionBlock?()
    }
    
    @IBAction func subProduct(sender: AnyObject) {
        if productDetail?.units == "шт" {
            guard quantity > 1 else { return }
            quantity -= 1
        } else {
            guard Int(productDetail?.weightAdd ?? "") ?? 0 > Int(productDetail?.weight ?? "") ?? 0 else { return }
            quantity -= Int((productDetail?.weight) ?? "") ?? 0
            xForWeight = (Int((productDetail?.weightAdd) ?? "") ?? 0)
            xForWeight -= (Int((productDetail?.weight)!)!)
        }
        updateProduct()
        completionBlock?()
    }
    
    func updateProduct () {
        let realm = try! Realm()
        let product = realm.objects(ProductsForRealm.self).filter("id  == [c] %@", productID).first
        try! realm.write {
            product?.quantity = "\(quantity)"
            product?.weightAdd = String(xForWeight)
        }
    }
    
    @IBAction func deleteProduct(sender: AnyObject) {
        let realm = try? Realm()
        guard let productDetail = productDetail else {
            return
        }
        _ = try? realm?.write {
            realm?.delete(productDetail)
            completionBlock?()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//                weightLabel.cornerRadius = 9.0
//                weightLabel.borderWidth = 1
                //weightLabel.borderColor = Color.Bezpaketov
    }
}
