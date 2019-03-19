//
//  Repository.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/19/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import Foundation

struct Reporitory {
    
    // MARK: Person Repostitory
    static func getAllPerson() -> [Person] {
        guard let realm = RealmManager.shared.realm else { return [] }
        let persons = realm.objects(Person.self).toArray(ofType: Person.self)
        return persons
    }
    
    static func getPerson(withId id: String) -> Person? {
        guard let realm = RealmManager.shared.realm else { return nil }
        let person = realm.objects(Person.self).filter("id = %@", id).toArray(ofType: Person.self).first
        return person
    }
    
    // MARK: Bill Repostitory
    static func getAllBill() -> [Bill] {
        guard let realm = RealmManager.shared.realm else { return [] }
        let bills = realm.objects(Bill.self).toArray(ofType: Bill.self)
        return bills
    }
    
    static func getBill(withId id: String) -> Bill? {
        guard let realm = RealmManager.shared.realm else { return nil }
        let bill = realm.objects(Bill.self).filter("id = %@", id).toArray(ofType: Bill.self).first
        return bill
    }
    
    // MARK: Relative Repostitory
    static func getRelative(withId id: String) -> Relative? {
        guard let realm = RealmManager.shared.realm else { return nil }
        let relative = realm.objects(Relative.self).filter("id = %@", id).toArray(ofType: Relative.self).first
        return relative
    }
}
