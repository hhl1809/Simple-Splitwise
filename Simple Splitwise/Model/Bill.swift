//
//  Bill.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/15/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import RealmSwift
import Realm

class Bill: Object {
    
    // MARK: - Properties
    @objc dynamic var id: String? = ""
    @objc dynamic var title: String? = ""
    @objc dynamic var total: Double = 0
    @objc dynamic var desc: String? = ""
    @objc dynamic var date: Double = 0
    @objc dynamic var paidBy: Person?
    var paidFor: List<Person>? = List<Person>()
    
    // MARK: - Init
    static func initialize(title: String, total: Double, desc: String, paidBy: Person, date: Double, paidFor: [Person]) -> Bill {
        let bill = Bill()
        bill.id = UUID().uuidString
        bill.title = title
        bill.total = total
        bill.desc = desc
        bill.date = date
        bill.paidBy = paidBy
        for person in paidFor {
            bill.paidFor?.append(person)
        }
        return bill
    }
    
}
