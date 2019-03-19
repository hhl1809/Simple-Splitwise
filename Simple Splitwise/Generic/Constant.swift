//
//  Constant.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/14/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import Foundation

struct APP_IMAGE {
    static let ADD_PERSON = "add-person-icon"
    static let EMAIL = "email-icon"
    static let CANCEL = "cancel-icon"
    static let ACCEPT = "accept-icon"
    static let BILL = "bill-icon"
    static let FACE = "face-icon"
    static let DELETE = "delete-icon"
    static let SALARY = "salary-icon"
}

struct APP_ERROR_MESSAGE {
    static let INVALID_EMAIL = "Your email is invalid. Please try again"
    static let INVALID_PHONE = "Your phone is invalid. Please try again"
}

enum DateFormat: String {
    
    /** Format: "yyyy-MM-dd" */
    case type001     =   "yyyy-MM-dd"
    
    /** Format: "dd/MM/yyyy" */
    case type002     =   "dd/MM/yyyy"
    
    /** Format: "yyyy-MM-dd'T'HH:mm:sszzzz" */
    case type003     =   "yyyy-MM-dd'T'HH:mm:sszzzz"
    
    /** Format: "dd/MM/yyyy HH:mm:ss" */
    case type004     =   "dd/MM/yyyy HH:mm:ss"
    
    /** Format: "dd/MM/yyyy hh:mm a" */
    case type005     =   "dd/MM/yyyy hh:mm a" //"2018-03-12T15:52:35.697
    
    /** Format: "dd/MM/yyyy HH:mm" */
    case type006     =   "dd/MM/yyyy HH:mm"
    
    /** Format: "yyyy-MM-dd'T'HH:mm:ss'Z'" */
    case type007     =   "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    /** Format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" */
    case type008     =   "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    /** Format: "yyyy-MM-dd HH:mm:ss Z" */
    case type009     =   "yyyy-MM-dd HH:mm:ss Z"
    
    /** Format: "yyyy-MM-dd'T'HH:mm:ss.SSS" */
    case type010     =   "yyyy-MM-dd'T'HH:mm:ss.SSS"
    
    /** Format: "hh:mm a" */
    case type011     =   "hh:mm a"
    
    /** Format: "YYYY-MM-DD'T'HH:mm:ss" */
    case type012     =   "YYYY-MM-dd'T'HH:mm:ss"
    
    /** Format: "dd MMMM yyyy" */
    case type014     =   "dd MMMM yyyy"
    
    /** Format: "dd" */
    case type015     =    "dd"
    
    /** Format: "MMM yyyy" */
    case type016     =    "MMM yyyy"
    
    /** Format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ" */
    case type017     =    "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    /** Format: "dd/MM HH:mm" */
    case type018     =    "dd/MM HH:mm"
    
    /** Format: "HH:mm" */
    case type019     =    "HH:mm"
    
    /** Format: "MMMM dd, yyyy" */
    case type020     =    "MMMM dd, yyyy"
    
    /** Format: "yyyy-MM-dd HH:mm:ss:SSS Z" */
    case type021     =    "yyyy-MM-dd HH:mm:ss:SSS Z"
    
    /** Format: "MMMM dd, yyyy HH:mm" */
    case type022     =    "MMMM dd, yyyy HH:mm"
    
    /** Format: "MMM dd, yyyy hh:mm a" */
    case type023     =    "MMM dd, yyyy hh:mm a"
}

enum AbbreviationTimeZone: String {
    
    /** Abbreviation: Current Time Zone */
    case current            = "Current"
    
    /** Abbreviation: "GMT" */
    case gmt                = "GMT"
    
    /** Abbreviation: "GMT+1" */
    case gmtPlus1           = "GMT+1"
    
    /** Abbreviation: "GMT+2" */
    case gmtPlus2           = "GMT+2"
    
    /** Abbreviation: "GMT+3" */
    case gmtPlus3           = "GMT+3"
    
    /** Abbreviation: "GMT+4" */
    case gmtPlus4           = "GMT+4"
    
    /** Abbreviation: "GMT+5" */
    case gmtPlus5           = "GMT+5"
    
    /** Abbreviation: "GMT+6" */
    case gmtPlus6           = "GMT+6"
    
    /** Abbreviation: "GMT+7" */
    case gmtPlus7           = "GMT+7"
    
    /** Abbreviation: "GMT+8" */
    case gmtPlus8           = "GMT+8"
    
    /** Abbreviation: "GMT+9" */
    case gmtPlus9           = "GMT+9"
    
    /** Abbreviation: "GMT+10" */
    case gmtPlus10          = "GMT+10"
    
    /** Abbreviation: "GMT+11" */
    case gmtPlus11          = "GMT+11"
    
    /** Abbreviation: "GMT+12" */
    case gmtPlus12          = "GMT+12"
    
    /** Abbreviation: "GMT-11" */
    case gmtMinus11         = "GMT-11"
    
    /** Abbreviation: "GMT-10" */
    case gmtMinus10         = "GMT-10"
    
    /** Abbreviation: "GMT-9" */
    case gmtMinus9          = "GMT-9"
    
    /** Abbreviation: "GMT-8" */
    case gmtMinus8          = "GMT-8"
    
    /** Abbreviation: "GMT-7" */
    case gmtMinus7          = "GMT-7"
    
    /** Abbreviation: "GMT-6" */
    case gmtMinus6          = "GMT-6"
    
    /** Abbreviation: "GMT-5" */
    case gmtMinus5          = "GMT-5"
    
    /** Abbreviation: "GMT-4" */
    case gmtMinus4          = "GMT-4"
    
    /** Abbreviation: "GMT-3" */
    case gmtMinus3          = "GMT-3"
    
    /** Abbreviation: "GMT-2" */
    case gmtMinus2          = "GMT-2"
    
    /** Abbreviation: "GMT-1" */
    case gmtMinus1          = "GMT-1"
    
}

enum SelectMode {
    case single
    case multiple
}

