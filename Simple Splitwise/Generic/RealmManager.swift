//
//  RealmManager.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/13/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import Realm
import RealmSwift

class RealmManager: NSObject {
    
    // MARK: - Properties
    static let shared = RealmManager()
    var realm: Realm?
    
    // MARK: - Init
    private override init() {
        super.init()
    }
    
    // MARK: - Functions
    func initRealm() -> Void {
        realm = try! Realm()
        
        if UserDefaults.isFirstLaunch() {
            let person = Person.initialize(name: "You", email: "", phone: "", age: 0)
            person.id = "YOU-ARE-MASTER"
            RealmManager.shared.add(object: person)
        }
        
    }
    
    func add(object: Object) -> Void {
        guard let realm = realm else { return }
        try! realm.write {
            realm.add(object)
        }
    }
    
    func update(person: Person) -> Void {
        guard let realm = realm else { return }
        let id = person.id ?? ""
        let object = Reporitory.getPerson(withId: id)
        
        try! realm.write {
            if let object = object {
                object.name = person.name
                object.email = person.email
                object.phone = person.phone
                object.age = person.age
                object.relatives?.removeAll()
                if let relatives = person.relatives {
                    for relative in relatives {
                        object.relatives?.append(relative)
                    }
                }
            }
        }
    }
    
    func update(bill: Bill) -> Void {
        guard let realm = realm else { return }
        let id = bill.id ?? ""
        let object = Reporitory.getBill(withId: id)
        
        try! realm.write {
            if let object = object {
                object.title = bill.title
                object.total = bill.total
                object.desc = bill.desc
                object.date = bill.date
                object.paidBy = bill.paidBy
                object.paidFor?.removeAll()
                if let paidFor = bill.paidFor {
                    for person in paidFor {
                        object.paidFor?.append(person)
                    }
                }
                
            }
        }
    }
    
    func update(relative: Relative) -> Void {
        guard let realm = realm else { return }
        let id = relative.id ?? ""
        let object = Reporitory.getRelative(withId: id)

        try! realm.write {
            if let object = object {
                object.creditor = relative.creditor
                object.debtor = relative.debtor
                object.billId = relative.billId
                object.amount = relative.amount
                object.date = relative.date
            }
        }
    }
}
