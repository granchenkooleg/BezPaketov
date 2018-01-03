//
//  InfoAboutUserForOrder.swift
//  Bezpaketov
//
//  Created by Oleg on 1/7/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

// For randonm string idOrder
let randomNum:UInt32 = arc4random_uniform(10000) // range is 0 to 9999

// Convert the UInt32 to some other  types
let someString:String = String(randomNum) //string works too


class InfoAboutUserForOrder : Object {
    
    
    
    @objc dynamic var idOrder = someString  //UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var city: String? = ""
    @objc dynamic var region: String? = ""
    @objc dynamic var street: String? = ""
    @objc dynamic var house: String? = ""
    @objc dynamic var porch: String? = ""
    @objc dynamic var apartment: String? = ""
    @objc dynamic var floor: String? = ""
    @objc dynamic var commit: String? = ""
    
    //dynamic var created = Date()
    
    @objc dynamic var owner: User?
    
    override class func primaryKey() -> String? {
        return "idOrder"
    }
    
    
    //path to Realm
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            print("FileURL of DataBase - \(url)")
        }
    }
    
    class func setupAllUserInfo(/*idOrder: String *//*= "",*/ name: String = "", phone: String = "", city: String = "", region: String = "", street: String = "", house: String = "", porch: String = "", apartment: String = "", floor: String = "", commit: String = "") {
        
        setConfig()
        
        let homeInfoUser: Dictionary = [
            /*"idOrder" : idOrder,*/
            "name" : name,
            "phone" : phone,
            "city" : city,
            "region" : region,
            "street" : street,
            "house" : house,
            "porch" : porch,
            "apartment" : apartment,
            "floor" : floor,
            "commit" : commit]
        
        let infoAboutUser = InfoAboutUserForOrder(value: homeInfoUser)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(infoAboutUser, update: true)
        }
    }
    
    static func deleteUserInfo() {
        let realm = try! Realm()
        let userInfo = realm.objects(InfoAboutUserForOrder.self)
        try! realm.write {
            realm.delete(userInfo)
        }
    }
    
}
