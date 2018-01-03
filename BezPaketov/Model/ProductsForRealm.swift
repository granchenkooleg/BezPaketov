//
//  ProductsForRealm.swift
//  Bezpaketov
//
//  Created by Oleg on 12/25/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ProductsForRealm : Object {
    
    @objc dynamic var quantity = ""
    @objc dynamic var id: String = ""
    @objc dynamic var descriptionForProduct: String? = ""
    @objc dynamic var proteins: String? = ""
    @objc dynamic var calories: String? = ""
    @objc dynamic var zhiry: String? = ""
    @objc dynamic var favorite: String? = ""
    @objc dynamic var category_id: String? = ""
    @objc dynamic var brand: String? = ""
    @objc dynamic var price_sale: String? = ""
    @objc dynamic var weight: String? = ""
    @objc dynamic var status: String? = ""
    @objc dynamic var expire_date: String? = ""
    @objc dynamic var price: String? = ""
    @objc dynamic var created_at: String? = ""
    @objc dynamic var icon: String? = ""
    @objc dynamic var category_name: String? = ""
    @objc dynamic var name: String? = ""
    @objc dynamic var uglevody: String? = ""
    @objc dynamic var units: String? = ""
    @objc dynamic var image: Data? = nil
    //dynamic var created = Date()
    
    @objc dynamic var owner: User?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //path to Realm
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            print("FileURL of DataBase - \(url)")
        }
    }
    
    class func setupProduct(id: String = "", descriptionForProduct: String = "", proteins: String = "", calories: String = "", zhiry: String = "", favorite: String = "", category_id: String = "", brand: String = "", price_sale: String = "", weight: String = "", status: String = "", expire_date: String = "", price: String = "", created_at: String = "", icon: String = "", category_name: String = "", name: String = "", uglevody: String = "", units: String = "", quantity: String = "", image: Data? = nil) -> ProductsForRealm {
        
        let productData: Dictionary <String, Any> = [
            "id" : id,
            "descriptionForProduct" : descriptionForProduct,
            "proteins" : proteins,
            "calories" : calories,
            "zhiry" : zhiry,
            "favorite" : favorite,
            "category_id" : category_id,
            "brand" : brand,
            "price_sale" : price_sale,
            "weight" : weight,
            "status" : status,
            "expire_date" : expire_date,
            "price" : price,
            "created_at" : created_at,
            "icon" : icon,
            "category_name" : category_name,
            "name" : name,
            "uglevody" : uglevody,
            "units" : units,
            "quantity" : quantity,
            "image": image ?? Data()]
        
        let product = ProductsForRealm(value: productData)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(product, update: true)
        }
        return product
    }
    
    static func deleteAllProducts() {
        let realm = try! Realm()
        let allProducts = realm.objects(ProductsForRealm.self)
        try! realm.write {
            realm.delete(allProducts)
        }
    }
}
