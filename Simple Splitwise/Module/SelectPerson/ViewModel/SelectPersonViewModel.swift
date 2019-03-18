//
//  SelectPersonViewModel.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/18/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift

struct SelectPersonViewModel {
    
    // MARK: Properties
    var listPerson: [Person]? = []
    var listData: Variable<Array<SectionModel<String, Object>>>? = Variable([])
    var selectedPersons: Variable<[Person]> = Variable([])
    
    // MARK: - Init
    init() {
        generateListPerson()
        generateListData()
    }
    
    // MARK: Functions
    mutating func generateListPerson() -> Void {
        guard let realm = RealmManager.shared.realm else { return }
        listPerson = realm.objects(Person.self).toArray(ofType: Person.self)
    }
    
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
        if let listPerson = self.listPerson?.sorted(by: { (p1, p2) -> Bool in
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
    
    func generatePersonCell(person: Person) -> GenericTableViewCell001Model {
        let name = person.name ?? ""
        let phone = person.phone ?? ""
        let id = person.id
        var isSelect = false
        
        if self.selectedPersons.value.count > 0 {
            for p in self.selectedPersons.value {
                if id == p.id {
                    isSelect = true
                    break
                }
            }
        }
        
        let model = GenericTableViewCell001Model(title: name, rightTitle: "", subtitle: phone, object: person, cellName: "\(id)", imageName: APP_IMAGE.FACE, isSelect: isSelect)
        return model
    }
    
    func reloadData() -> Void {
        if let listData = self.listData?.value {
            self.listData?.value.removeAll()
            self.listData?.value = listData
        }
    }

}
