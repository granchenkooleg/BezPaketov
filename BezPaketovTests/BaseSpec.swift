//
//  BaseSpec.swift
//  BezPaketov
//
//  Created by Oleg on 11/25/17.
//  Copyright © 2017 Oleg Granchenko. All rights reserved.
//

import Quick
import Nimble
import RealmSwift

class BaseSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        beforeSuite {
            self.useTestDatabase()
        }
        
        beforeEach {
            self.clearDatabase()
        }
    }
}

extension BaseSpec {
     //    When we’re testing, we may create/update or delete some records from the Realm database. We don’t want those changes to affect the production database. If we let that happens, it would become a disaster.
     //    What we’re gonna do is we direct all Realm operations into a test database instead of the real one. Realm provides a very convenient way to do exactly just that.
    func useTestDatabase() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
     //  Additionally, we wanna clear out all records so that each test would start with a fresh empty database. Override the beforeEach and put in the code to delete everything within Realm.
    func clearDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
