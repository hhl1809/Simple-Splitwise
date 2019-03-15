//
//  AddPersonViewModel.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/15/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import RxSwift
import RxCocoa

struct AddPersonViewModel {
    let name: Variable<String> = Variable("")
    let email: Variable<String> = Variable("")
    let phone: Variable<String> = Variable("")
    let age: Variable<String> = Variable("")
}
