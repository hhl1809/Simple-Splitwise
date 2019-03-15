//
//  HomeViewModel.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/13/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import RxSwift
import RxCocoa
import Realm
import RealmSwift

struct HomeViewModel {
    
    // MARK: Properties
    var listPerson: [Person]? = []
    var listAlphabet: [Character]? = []
    var listData: [Any]? = []
    
    // MARK: - Init
    init() {
        generateListAlphabet()
        generateListPerson()
    }
    
    // MARK: Functions
    mutating func generateListAlphabet() -> Void {
        let aScalars = "A".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value
        self.listAlphabet = (0..<26).map { i in Character(UnicodeScalar(aCode + i)!) }
    }
    
    mutating func generateListPerson() -> Void {
        guard let realm = RealmManager.shared.realm else { return }
        listPerson = realm.objects(Person.self).toArray(ofType: Person.self)
    }
    
    mutating func filterListPersonByAlphabet() -> Void {
        self.listData?.removeAll()
        if let listPerson = self.listPerson, listPerson.count > 0, let listAlphabet = self.listAlphabet, listAlphabet.count > 0, var listData = self.listData {
            for char in listAlphabet {
                var tempArray: [Person] = []
                for person in listPerson {
                    if person.name.first == char {
                        tempArray.append(person)
                    }
                }
                if tempArray.count > 0 {
                    let sectionModel = SectionModel(model: "\(char)", items: tempArray)
                    listData.append(sectionModel)
                }
            }
            self.listData = listData
        }
    }
}
