//
//  DateUtility.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/18/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import Foundation

class DateUtility {
    
    static func convertTimestampToDate(withTimestamp timestamp: Double) -> Date {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        return date
    }
    
    static func convertTimestampToString(withTimestamp timestamp: Double, format: DateFormat, abbreviationTimeZone: String = AbbreviationTimeZone.current.rawValue) -> String {
        let date = convertTimestampToDate(withTimestamp: timestamp)
        let dateString = convertDateToString(withDate: date, format: format, abbreviationTimeZone: abbreviationTimeZone)
        return dateString
        
    }
    
    static func convertDateToString(withDate date: Date, format: DateFormat, abbreviationTimeZone: String = AbbreviationTimeZone.current.rawValue) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        if abbreviationTimeZone == AbbreviationTimeZone.current.rawValue {
            formatter.timeZone = TimeZone.current
        } else {
            formatter.timeZone = TimeZone(abbreviation: abbreviationTimeZone) // Abbreviation example "GMT+7"
        }
        return formatter.string(from: date)
    }
    
    static func convertStringToDate(string: String, format: DateFormat, abbreviationTimeZone: String = AbbreviationTimeZone.current.rawValue) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        if abbreviationTimeZone == AbbreviationTimeZone.current.rawValue {
            formatter.timeZone = TimeZone.current
        } else {
            formatter.timeZone = TimeZone(abbreviation: abbreviationTimeZone) // Abbreviation example "GMT+7"
        }
        
        let date = formatter.date(from: string)
        return date
    }
    
    static func convertDateToTimestamp(withDate date : Date, format: DateFormat = DateFormat.type002, abbreviationTimeZone: String = AbbreviationTimeZone.current.rawValue) -> Double {
        var dateString: String = ""
        
        dateString = convertDateToString(withDate: date, format: format, abbreviationTimeZone: abbreviationTimeZone)
        
        if let resultDate = convertStringToDate(string: dateString, format: format, abbreviationTimeZone: abbreviationTimeZone) {
            return resultDate.timeIntervalSince1970.rounded() * 1000
        } else {
            return 0
        }
    }
    
    static func convertStringToTimestamp(string: String, format: DateFormat, abbreviationTimeZone: String = AbbreviationTimeZone.current.rawValue) -> Double {
        if let result = convertStringToDate(string: string, format: format, abbreviationTimeZone: abbreviationTimeZone) {
            return convertDateToTimestamp(withDate: result, format: format, abbreviationTimeZone: abbreviationTimeZone)
        } else {
            return 0
        }
        
    }
    
    
}
