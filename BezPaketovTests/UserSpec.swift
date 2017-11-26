//
//  BezPaketovTests.swift
//  BezPaketovTests
//
//  Created by Oleg on 11/25/17.
//  Copyright © 2017 Oleg Granchenko. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RealmSwift
@testable import BezPaketov

class UserSpec: BaseSpec {
    override func spec() {
        super.spec()
        
        describe("models") {
            describe("initialize with id, firstName, lastName, email, phone") {
                it("initializes correctly") {
                    User.setupUser(id:"1", firstName:"name:A", lastName:"surname:G", email:"a@gmail.com", phone:"0500000000")
                    
                    let user: User? = {
                        let realm = try! Realm()
                        let user = realm.objects(User.self).first
                        
                        return user
                    }()
                    
                    expect(user?.id) == "1"
                    expect(user?.firstName) == "name:A"
                    expect(user?.lastName) == "surname:G"
                    expect(user?.email) == "a@gmail.com"
                    expect(user?.phone) == "0500000000"
                }
            }
            
            
            describe("relationships") {
                let productsBelongTo = "products name:A surname:G"
                
                describe("to-one relationship") {
                    it("saves the object and its relationship to database correctly") {
                        User.setupUser(id:"1", firstName:"name:A", lastName:"surname:G", email:"a@gmail.com", phone:"0500000000")
                        
                        let user: User? = {
                            let realm = try! Realm()
                            let user = realm.objects(User.self).first
                            
                            return user
                        }()
                        
                        ProductsForRealm.setupProduct(id:"11", descriptionForProduct:"Milk it's...", proteins:"44", calories:"500", zhiry:"5", favorite:"5", category_id:"16", brand:"MG", price_sale:"20", weight:"13", weightAdd:"39", status:"1", expire_date:"10.10.18", price:"50", created_at:"01.09.17", icon:"Milk.png", category_name:"MilkProducts", name:productsBelongTo, uglevody:"22", units:"kg", quantity: "100", image:nil)
                        
                        let productsForRealm: ProductsForRealm? = {
                            let realm = try! Realm()
                            let productsForRealm = realm.objects(ProductsForRealm.self).first
                            
                            return productsForRealm
                        }()
                        
                        let realm = try! Realm()
                        try! realm.write {
                            productsForRealm?.owner = user
                            realm.add(productsForRealm!)
                        }
                        
                        let productsFromDatabase = realm.objects(ProductsForRealm.self).last
                        expect(productsFromDatabase?.id) == "11"
                        expect(productsFromDatabase?.descriptionForProduct) == "Milk it's..."
                        expect(productsFromDatabase?.proteins) == "44"
                        expect(productsFromDatabase?.calories) == "500"
                        expect(productsFromDatabase?.zhiry) == "5"
                        expect(productsFromDatabase?.favorite) == "5"
                        expect(productsFromDatabase?.category_id) == "16"
                        expect(productsFromDatabase?.brand) == "MG"
                        expect(productsFromDatabase?.price_sale) == "20"
                        expect(productsFromDatabase?.weight) == "13"
                        expect(productsFromDatabase?.weightAdd) == "39"
                        expect(productsFromDatabase?.status) == "1"
                        expect(productsFromDatabase?.expire_date) == "10.10.18"
                        expect(productsFromDatabase?.price) == "50"
                        expect(productsFromDatabase?.created_at) == "01.09.17"
                        expect(productsFromDatabase?.icon) == "Milk.png"
                        expect(productsFromDatabase?.category_name) == "MilkProducts"
                        expect(productsFromDatabase?.name) == productsBelongTo
                        expect(productsFromDatabase?.uglevody) == "22"
                        expect(productsFromDatabase?.units) == "kg"
                        expect(productsFromDatabase?.quantity) == "100"
                        expect(productsFromDatabase?.image) == Data()
                        expect(productsFromDatabase?.owner?.firstName) == user?.firstName
                        expect(productsFromDatabase?.owner?.lastName) == user?.lastName
                    }
                }
                
                
                describe("to-many relationship") {
                    it("saves the object and its relationship to database correctly") {
                        User.setupUser(id:"1", firstName:"name:A", lastName:"surname:G", email:"a@gmail.com", phone:"0500000000")
                        
                        let user: User? = {
                            let realm = try! Realm()
                            let user = realm.objects(User.self).first
                            
                            return user
                        }()
                        
                        let product0 = ProductsForRealm.setupProduct(id:"11", descriptionForProduct:"Milk it's...", proteins:"44", calories:"500", zhiry:"5", favorite:"5", category_id:"16", brand:"MG", price_sale:"20", weight:"13", weightAdd:"39", status:"1", expire_date:"10.10.18", price:"50", created_at:"01.09.17", icon:"Milk.png", category_name:"MilkProducts", name:"products_0", uglevody:"22", units:"kg", quantity: "100", image:nil)
                        
                        let product1 = ProductsForRealm.setupProduct(id:"12", descriptionForProduct:"Orange it's...", proteins:"14", calories:"200", zhiry:"2", favorite:"5", category_id:"17", brand:"MG", price_sale:"21", weight:"10", weightAdd:"39", status:"1", expire_date:"10.09.18", price:"30", created_at:"01.09.18", icon:"Orange.png", category_name:"FruitProducts", name:"products_1", uglevody:"12", units:"kg", quantity: "100", image:nil)
                        
                        let realm = try! Realm()
                        try! realm.write {
                            user?.products.append(product0)
                            user?.products.append(product1)
                            realm.add(user!)
                        }
                        
                        let userFromDatabase = realm.objects(User.self).last
                        expect(userFromDatabase?.products.count) == 2
                        expect(userFromDatabase?.products[0].name) == "products_0"
                        expect(userFromDatabase?.products[1].name) == "products_1"
                    }
                }
            }
            
            
            describe("Verification operations") {
                describe("Check user if he is Authorized") {
                    it("give to user additional options") {
                        User.setupUser(id:"1", firstName:"name:A", lastName:"surname:G", email:"a@gmail.com", phone:"0500000000")
                        
                        self.createUsers(1)
                        expect(User.isAuthorized()) == true
                    }
                }
            }
            
            
            describe("Delete") {
                it("deletes records from database") {
                    self.createUsers(1)
                    User.deleteUser()
                    let users = User.currentUser
                    expect(users?.firstName) == ""
                    expect(users?.lastName) == ""
                }
            }
        }
    }
}


extension UserSpec {
    func createUsers(_ number: Int) {
        for i in 0..<number {
            User.setupUser(id: "\(i)", firstName: "userName \(i)", lastName:"UserSurname \(i)", email:"a_\(i)@gmail.com", phone:"050000000\(i)")
        }
    }
}
