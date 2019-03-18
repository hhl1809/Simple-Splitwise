//
//  BillDetailViewModel.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/18/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import RxSwift
import RxCocoa
import Realm
import RealmSwift

struct BillDetailViewModel {
    
    // MARK: - Properties
    var date: Double = 0
    var paidBy: Person?
    var paidFor: [Person]? = []
    var listData: Variable<Array<SectionModel<String, Object>>>? = Variable([])
    var total: Double = 0
    var title: String = ""
    var description: String = ""
    
    // MARK: - Init
    init() {
        generateListData()
    }
    
    // MARK: Functions
    mutating func generateListData() -> Void {
        self.listData?.value.removeAll()
        if var listData =  self.listData?.value {
            if let listSection = initDataFromListPerson() {
                listData = listSection
            }

            self.listData?.value = listData
        }
    }
    
    mutating func initDataFromListPerson() -> [SectionModel<String, Object>]? {
        if let listPerson = self.paidFor?.sorted(by: { (p1, p2) -> Bool in
            return p1.name ?? "" < p2.name ?? ""
        }) , listPerson.count > 0 {
            var listSection: [SectionModel<String, Object>] = []

            var items: [Object] = []
            for person in listPerson {
                items.append(person as Object)
            }
            if items.count > 0 {
                let sectionModel = SectionModel(model: "", items: items)
                listSection.append(sectionModel)
            }

            return listSection
        }
        return nil
    }

    func generatePersonCell(person: Person) -> GenericTableViewCell002Model {
        let name = person.name ?? ""
        let id = person.id
        var inputText = ""
        if let listPerson = self.paidFor, listPerson.count > 0 {
            inputText = String(format: "%.2f", total/Double(listPerson.count)) 
        }

        let model = GenericTableViewCell002Model(title: "\(name) need to pay ", inputText: inputText, inputTextColor: UIColor.pink(), rightTitle: "VND", object: person, cellName: "\(id)", imageName: APP_IMAGE.DELETE)

        return model
    }
}
