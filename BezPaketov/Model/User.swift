
//  User.swift
//  Bezpaketov
//
//  Created by Macostik on 12/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

var token: NotificationToken?

class User: Object {
    
    @objc dynamic var id: String? = "1" // or dynamic var id = UUID().uuidString
    @objc dynamic var idUser = ""
    @objc dynamic var firstName: String? = ""
    @objc dynamic var lastName: String? = ""
    @objc dynamic var email: String? = ""
    @objc dynamic var password: String? = ""
    @objc dynamic var phone: String? = ""
    var products = List<ProductsForRealm>()
    var homeUserData = List<InfoAboutUserForOrder>()
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    deinit {
    }
    
    
    class func setupUser(id: String = "", firstName: String = "", lastName: String = "", email: String = "", phone: String = "") {
        
        let userData: Dictionary = [
            "idUser" :          id,
            "firstName" :   firstName,
            "lastName" :    lastName,
            "email" :       email,
            "phone" :       phone]
        
        let user = User(value: userData)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    static var currentUser: User? = {
        let realm = try! Realm()
        let user = realm.objects(User.self).first
        
        return user
    }()
    
    static func deleteUser() {
        let realm = try! Realm()
        guard let user = realm.objects(User.self).first else { return }
        try! realm.write {
            user.idUser = ""
            user.firstName = ""
            user.lastName = ""
            user.email = ""
            user.password = ""
            user.phone = ""
            realm.add(user, update: true)
        }
    }
    
    func fullName() -> String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    
    func save() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(User.currentUser ?? User(), update: true)
        }
    }
    
    class func isAuthorized() -> Bool {
        let realm = try! Realm()
        
        guard let user = realm.objects(User.self).first, user.idUser.isEmpty == false else { return false }
        return true
    }
}

