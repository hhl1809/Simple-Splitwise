//
//  Relative.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/19/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Relative: Object {
    
    // MARK: - Properties
    @objc dynamic var id: String? = ""
    @objc dynamic var creditor: Person?
    @objc dynamic var debtor: Person?
    @objc dynamic var billId: String? = ""
    @objc dynamic var amount: Double = 0
    @objc dynamic var date: Double = 0
    
    // MARK: - Init
    static func initialize(creditor: Person, debtor: Person,billId: String, amount: Double, date: Double) -> Relative {
        let relative = Relative()
        relative.id = UUID().uuidString
        relative.creditor = creditor
        relative.debtor = debtor
        relative.billId = billId
        relative.amount = amount
        relative.date = date
        return relative
    }
    
}
