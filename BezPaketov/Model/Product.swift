//
//  Product.swift
//  Bezpaketov
//
//  Created by Macostik on 12/4/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import RealmSwift

struct Products {
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

class Product : Object {
    
    @objc dynamic var favoriteProductOfUser = false
    @objc dynamic var id = ""
    @objc dynamic var description_ = ""
    @objc dynamic var proteins = ""
    @objc dynamic var calories = ""
    @objc dynamic var zhiry = ""
    @objc dynamic var favorite = ""
    @objc dynamic var category_id = ""
    @objc dynamic var brand = ""
    @objc dynamic var price_sale = ""
    @objc dynamic var weight = ""
    @objc dynamic var status = ""
    @objc dynamic var expire_date = ""
    @objc dynamic var price = ""
    @objc dynamic var created_at = ""
    @objc dynamic var icon = ""
    @objc dynamic var category_name = ""
    @objc dynamic var name = ""
    @objc dynamic var uglevody = ""
    @objc dynamic var units = ""
    @objc dynamic var image: Data? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            Logger.log("FileURL of DataBase - \(url)", color: .Orange)
        }
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
                                                image: Data?  = nil) -> Product {
        
        let productData: Dictionary<String, Any> = [
            "id" :          id,
            "description_" :   description_,
            "proteins" :    proteins,
            "calories" :       calories,
            "zhiry" :       zhiry,
            "favorite" : favorite,
            "category_id": category_id,
            "brand" :   brand,
            "price_sale" :    price_sale,
            "weight" :       weight,
            "status" :       status,
            "expire_date" : expire_date,
            "price" :   price,
            "created_at" :    created_at,
            "icon" :       icon,
            "category_name" :       category_name,
            "name" : name,
            "uglevody" :    uglevody,
            "units" :       units,
            "image" : image ?? Data()]
        
        let product = Product(value: productData)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(product, update: true)
        }
        return product
    }
    
    func allProducts() -> [Product] {
        let realm = try! Realm()
        return realm.objects(Product.self).array(ofType: Product.self)
    }
    
    static func delAllProducts() {
        let realm = try! Realm()
        let allProducts = realm.objects(Product.self)
        try! realm.write {
            realm.delete(allProducts)
        }
    }
}

class FavoriteProduct: Object{
    @objc dynamic var id = ""
    @objc dynamic var description_ = ""
    @objc dynamic var proteins = ""
    @objc dynamic var calories = ""
    @objc dynamic var zhiry = ""
    @objc dynamic var favorite = ""
    @objc dynamic var category_id = ""
    @objc dynamic var brand = ""
    @objc dynamic var price_sale = ""
    @objc dynamic var weight = ""
    @objc dynamic var status = ""
    @objc dynamic var expire_date = ""
    @objc dynamic var price = ""
    @objc dynamic var created_at = ""
    @objc dynamic var icon = ""
    @objc dynamic var category_name = ""
    @objc dynamic var name = ""
    @objc dynamic var uglevody = ""
    @objc dynamic var units = ""
    @objc dynamic var image: Data? = nil
    
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
