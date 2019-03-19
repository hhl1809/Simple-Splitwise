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
    var listBill: [Bill]? = []
    var listData: Variable<Array<SectionModel<String, Object>>>? = Variable([])
    
    // MARK: - Init
    init() {
        generateListAlphabet()
        generateListPerson()
        generateListBill()
    }
    
    // MARK: Functions
    mutating func generateListAlphabet() -> Void {
        let aScalars = "A".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value
        self.listAlphabet = (0..<26).map { i in Character(UnicodeScalar(aCode + i)!) }
    }
    
    mutating func generateListPerson() -> Void {
        listPerson = Reporitory.getAllPerson()
    }
    
    mutating func generateListBill() -> Void {
        listBill = Reporitory.getAllBill()

    }
    
    mutating func generateListData(index: Int) -> Void {
        self.listData?.value.removeAll()
        if var listData =  self.listData?.value {
            if index == 0 {
                if let listSection = initDataFromListPerson() {
                    listData = listSection
                }
            } else {
                if let listSection = initDataFromListBill() {
                    listData = listSection
                }
            }
            
            self.listData?.value = listData
        }
    }
    
    mutating func initDataFromListPerson() -> [SectionModel<String, Object>]? {
        if let listPerson = self.listPerson, listPerson.count > 0, let listAlphabet = self.listAlphabet, listAlphabet.count > 0 {
            var listSection: [SectionModel<String, Object>] = []
            
            for char in listAlphabet {
                var items: [Object] = []
                for person in listPerson {
                    let name = person.name ?? ""
                    if let firstChar = name.uppercased().first {
                        if firstChar == char {
                            items.append(person as Object)
                        }
                    }
                }
                if items.count > 0 {
                    let sectionModel = SectionModel(model: "\(char)", items: items)
                    listSection.append(sectionModel)
                }
            }
            
            var otherItems: [Object] = []
            for person in listPerson {
                let name = person.name ?? ""
                if let firstChar = name.uppercased().first {
                    if listAlphabet.index(of: firstChar) == nil {
                        otherItems.append(person as Object)
                    }
                }
            }
            if otherItems.count > 0 {
                let sectionModel = SectionModel(model: "#", items: otherItems)
                listSection.append(sectionModel)
            }
            
            return listSection
        }
        return nil
    }
    
    mutating func initDataFromListBill() -> [SectionModel<String, Object>]? {
        if let listBill = self.listBill, listBill.count > 0 {
            var listSection: [SectionModel<String, Object>] = []
            var tempArray: [Object] = []
            for bill in listBill {
                tempArray.append(bill as Object)
            }
            if tempArray.count > 0 {
                let sectionModel = SectionModel(model: "", items: tempArray)
                listSection.append(sectionModel)
            }
            return listSection
        }
         return nil
    }
    
    func generatePersonCell(person: Person) -> GenericTableViewCell001Model {
        let name = person.name ?? ""
        let phone = person.phone ?? ""
        let id = person.id ?? ""
        let model = GenericTableViewCell001Model(title: name, rightTitle: "", subtitle: phone, object: person, cellName: id, imageName: APP_IMAGE.FACE)
        return model
    }
    
    func generateBillCell(bill: Bill) -> GenericTableViewCell001Model {
        let name = bill.title ?? ""
        let total = bill.total
        let date = DateUtility.convertTimestampToString(withTimestamp: bill.date, format: DateFormat.type002)
        let id = bill.id ?? ""
        let paidBy = bill.paidBy?.name ?? ""
        let model = GenericTableViewCell001Model(title: name, rightTitle: date, subtitle: "Total: \(total) VND - Paid by: \(paidBy)", object: bill, cellName: id, imageName: APP_IMAGE.BILL)
        return model
    }
}
