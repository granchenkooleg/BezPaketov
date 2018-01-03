//
//  Category.swift
//  Bezpaketov
//
//  Created by Macostik on 12/5/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import RealmSwift

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
    var id = ""
    var icon = ""
    var name = ""
    var created_at = ""
    var units = ""
    var category_id = ""
    var image = Data()
}

class Category: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var icon = ""
    @objc dynamic var name = ""
    @objc dynamic var created_at = ""
    @objc dynamic var units = ""
    @objc dynamic var category_id = ""
    @objc dynamic var image: Data? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @discardableResult class func setupCategory(id: String = "",
                                                icon: String = "",
                                                name: String = "",
                                                created_at: String = "",
                                                units: String = "",
                                                category_id: String = "",
                                                image: Data? = nil) -> Category {
        
        let categoryData: Dictionary<String, Any> = [
            "id": id,
            "icon": icon,
            "name": name,
            "created_at": created_at,
            "units": units,
            "category_id": category_id,
            "image": image ?? Data()]
        
        let category = Category(value: categoryData)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(category, update: true)
        }
        return category
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

