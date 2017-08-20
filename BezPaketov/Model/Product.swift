//
//  Product.swift
//  Bezpaketov
//
//  Created by Macostik on 12/4/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

struct Products {
    var valuesUnitForWeightAfterRework = ""
    var valuesValueForWeightAfterRework = ""
    var id = ""
    var description = ""
    var proteins = ""
    var calories = ""
    var zhiry = ""
    var favorite = ""
    var category_id = ""
    var brand = ""
    var price_sale = ""
    var weight = ""
    var status = ""
    var expire_date = ""
    var price = ""
    var created_at = ""
    var icon = ""
    var category_name = ""
    var name = ""
    var uglevody = ""
    var units = ""
    var image = Data()
}


class Values : Object {
    dynamic var value: String? = nil
    dynamic var unit: String? = nil
    
}

class Product : Object {
    
    dynamic var zhiry: String? = nil
    dynamic var weight: String? = nil
    dynamic var status: String? = nil
    dynamic var category_name: String? = nil
    dynamic var favorite: String? = nil
    dynamic var icon: String? = nil
    dynamic var brand: String? = nil
    dynamic var calories: String? = nil
    dynamic var proteins: String? = nil
    dynamic var count: String? = nil
    dynamic var min_count: String? = nil
    dynamic var name: String? = nil
    dynamic var expire_date: String? = nil
    dynamic var id: String? = nil
    dynamic var price_sale: String? = nil
    dynamic var created_at: String? = nil
    dynamic var price: String? = nil
    dynamic var category_id: String? = nil
    dynamic var uglevody: String? = nil
    dynamic var unit_id: String? = nil
    dynamic var description_: String? = nil
    var values = List<Values>()
    
//        var valuesUnitForWeightAfterRework = ""
//        var valuesValueForWeightAfterRework = ""
    
//        dynamic var favoriteProductOfUser = false
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @discardableResult class func setupProduct(json: JSON) -> Product {
        var productList = Product()
        let realm = try! Realm()
        
        try! realm.write {
            for product in json.arrayValue {
                productList = realm.create((Product.self), value: product.object, update: true)
                productList.description_ = product["description"].stringValue
            }
        }
        return productList
    }
    
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            Logger.log("FileURL of DataBase - \(url)", color: .Orange)
        }
    }
    
    func allProducts() -> [Product] {
        let realm = try! Realm()
        return realm.objects(Product.self).array(ofType: Product.self)
    }
    
    static func delAllProducts() {
        let realm = try! Realm()
        let allProducts = realm.objects(Product.self)
        let allValues = realm.objects(Values.self)
        try! realm.write {
            realm.delete(allProducts)
            realm.delete(allValues)
        }
    }
}

class FavoriteProduct: Object{
    dynamic var id = ""
    dynamic var description_ = ""
    dynamic var proteins = ""
    dynamic var calories = ""
    dynamic var zhiry = ""
    dynamic var favorite = ""
    dynamic var category_id = ""
    dynamic var brand = ""
    dynamic var price_sale = ""
    dynamic var weight = ""
    dynamic var status = ""
    dynamic var expire_date = ""
    dynamic var price = ""
    dynamic var created_at = ""
    dynamic var icon = ""
    dynamic var category_name = ""
    dynamic var name = ""
    dynamic var uglevody = ""
    dynamic var units = ""
    dynamic var image: Data? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @discardableResult class func setupProduct( id: String = "",
                                                description_: String = "",
                                                proteins: String = "",
                                                calories: String = "",
                                                zhiry: String = "",
                                                favorite: String = "",
                                                category_id: String = "",
                                                brand: String = "",
                                                price_sale: String = "",
                                                weight: String = "",
                                                status: String = "",
                                                expire_date: String = "",
                                                price: String = "",
                                                created_at: String = "",
                                                icon: String = "",
                                                category_name: String = "",
                                                name: String = "",
                                                uglevody: String = "",
                                                units: String = "",
                                                image: Data?  = nil) -> FavoriteProduct {
        
        let productData: Dictionary<String, Any> = [
            "id" :            id,
            "description_":   description_,
            "proteins":       proteins,
            "calories":       calories,
            "zhiry":          zhiry,
            "favorite":       favorite,
            "category_id":    category_id,
            "brand":          brand,
            "price_sale":     price_sale,
            "weight":         weight,
            "status":         status,
            "expire_date":    expire_date,
            "price":          price,
            "created_at":     created_at,
            "icon":           icon,
            "category_name" : category_name,
            "name":           name,
            "uglevody" :      uglevody,
            "units":          units,
            "image":          image ?? Data()]
        
        let product = FavoriteProduct(value: productData)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(product, update: true)
        }
        return product
    }
    
    func allProducts() -> [FavoriteProduct] {
        let realm = try! Realm()
        return realm.objects(FavoriteProduct.self).array(ofType: FavoriteProduct.self)
    }
}
