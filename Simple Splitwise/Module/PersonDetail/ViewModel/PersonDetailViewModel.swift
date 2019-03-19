//
//  PersonDetailViewModel.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/18/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

struct PersonDetailViewModel {
    
    // MARK: Properties
    var person: Person?
    let name: Variable<String> = Variable("")
    let email: Variable<String> = Variable("")
    let phone: Variable<String> = Variable("")
    let age: Variable<String> = Variable("")
    var listRelative: [Relative]? = []
    var listData: Variable<Array<SectionModel<String, Object>>>? = Variable([])
    
    // MARK: - Init
    mutating func generateListRelative() -> Void {
        if let person = person, let relatives = person.relatives {
            for relative in relatives {
                listRelative?.append(relative)
            }
        }
    }
    
    mutating func generateListData() -> Void {
        self.listData?.value.removeAll()
        if var listData =  self.listData?.value {
            if let listSection = initDataFromListRelative() {
                listData = listSection
            }
            
            self.listData?.value = listData
        }
    }
    
    mutating func initDataFromListRelative() -> [SectionModel<String, Object>]? {
        if let listRelative = self.listRelative?.sorted(by: { (p1, p2) -> Bool in
            return p1.date > p2.date
        }) , listRelative.count > 0 {
            var listSection: [SectionModel<String, Object>] = []
            
            var items: [Object] = []
            for relative in listRelative {
                items.append(relative as Object)
            }
            if items.count > 0 {
                let sectionModel = SectionModel(model: "", items: items)
                listSection.append(sectionModel)
            }
            
            return listSection
        }
        return nil
    }
    
    func generateRelativeCell(relative: Relative) -> GenericTableViewCell001Model? {
        guard let creditor = relative.creditor else { return nil }
        guard let debtor = relative.debtor else { return nil }
        guard let bill = Reporitory.getBill(withId: relative.billId ?? "") else { return nil }
        guard let person = self.person else { return nil }
        let billTitle = bill.title ?? ""
        let dateString = DateUtility.convertTimestampToString(withTimestamp: relative.date, format: DateFormat.type020)
        let subtitle = "For: \(billTitle) bill - At: \(dateString)"
        var rightTitleTextColor = UIColor.blueGreen()
        let id = relative.id ?? ""
        let creditorName = creditor.name ?? ""
        let debtorName = debtor.name ?? ""
        let debtorId = debtor.id ?? ""
        let personId = person.id ?? ""
        if personId == debtorId {
            rightTitleTextColor = UIColor.pink()
        }
        let title = "\(debtorName) owned \(creditorName)"
        let rightTitle = "\(String(format: "%.2f", relative.amount)) VND"
        
        let model = GenericTableViewCell001Model(title: title, rightTitle: rightTitle, rightTitleTextColor: rightTitleTextColor, subtitle: subtitle, object: relative, cellName: id, imageName: APP_IMAGE.SALARY, isSelect: false)
        return model
    }

    
    
}
