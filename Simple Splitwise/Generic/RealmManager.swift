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
    }
    
    func add(object: Object) -> Void {
        guard let realm = realm else { return }
        try! realm.write {
            realm.add(object)
        }
    }
}
