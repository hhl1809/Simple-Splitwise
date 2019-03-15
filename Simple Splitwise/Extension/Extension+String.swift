//
//  Extension+String.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/14/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import Foundation

extension String {
    
    // Validate Email
    public var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    // Validate Phone Number
    public var isPhone: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "([+]?1+[-]?)?+([(]?+([0-9]{3})?+[)]?)?+[-]?+[0-9]{3}+[-]?+[0-9]{4}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
}
