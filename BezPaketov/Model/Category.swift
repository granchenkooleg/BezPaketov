//
//  Category.swift
//  Bezpaketov
//
//  Created by Macostik on 12/5/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

extension Object {
    static func getObject(by id: Int) -> Object? {
        let realm = try! Realm()
        guard let object = realm.objects(self).filter("id == \(id)").first else { return nil }
        return object
    }
}

extension Results {
    func array<T>(ofType: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}

struct CategoryStruct {
    var icon = ""
    var id = ""
    var name = ""
//    var created_at = ""
//    var units = ""
//    var category_id = ""
//    var image = Data()
}

class Category: Object {
    dynamic var icon = ""
    dynamic var id = ""
    dynamic var name = ""
//    dynamic var created_at = ""
//    dynamic var units = ""
//    dynamic var category_id = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @discardableResult class func setupCategory(json: JSON) -> Category {
        var categoryList = Category()
        let realm = try! Realm()
        
        try! realm.write {
            for category in json.arrayValue {
                categoryList = realm.create((Category.self), value: category.object, update: true)
            }
        }
        return categoryList
    }
    
    func allCategories() -> [Category] {
        let realm = try! Realm()
        return realm.objects(Category.self).array(ofType: Category.self)
    }
    
    
    static func delAllCategories() {
        let realm = try! Realm()
        let allCategories = realm.objects(Category.self)
        try! realm.write {
            realm.delete(allCategories)
        }
    }
}

