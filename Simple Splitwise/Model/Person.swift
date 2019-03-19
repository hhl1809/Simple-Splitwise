//
//  Person.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/13/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Person: Object {
    
    // MARK: - Properties
    @objc dynamic var id: String? = ""
    @objc dynamic var name: String? = ""
    @objc dynamic var email: String? = ""
    @objc dynamic var phone: String? = ""
    @objc dynamic var age: Int = 0
    var relatives: List<Relative>? = List<Relative>()
    
    // MARK: - Init
    static func initialize(name: String, email: String, phone: String, age: Int) -> Person {
        let person = Person()
        person.id = UUID().uuidString
        person.name = name
        person.email = email
        person.phone = phone
        person.age = age
        return person
    }
    
}
