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
            person.id = 1
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
        let id = person.id
        let objects = realm.objects(Person.self).filter("id = %@", id).toArray(ofType: Person.self)

        try! realm.write {
            if let object = objects.first {
                object.name = person.name
                object.email = person.email
                object.phone = person.phone
                object.age = person.age
            }
        }
    }
    
    func update(bill: Bill) -> Void {
        guard let realm = realm else { return }
        let id = bill.id
        let objects = realm.objects(Bill.self).filter("id = %@", id).toArray(ofType: Bill.self)
        
        try! realm.write {
            if let object = objects.first {
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
}
