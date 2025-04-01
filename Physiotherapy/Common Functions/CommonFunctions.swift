//
//  CommonFunctions.swift
//  Physiotherapy
//
//  Created by Priya Dube on 05/07/23.
//

import Foundation

class CommomFunctions : ObservableObject {
    
    func getCurrentDate() -> String {
        var currentDateString: String = ""
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        currentDateString = formatter.string(from: currentDate)
        return currentDateString
    }
    
    func getCurrentDateandTime()-> String{
        var currentDateString: String = ""
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy h:mma"
        formatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        currentDateString = formatter.string(from: currentDate)
        return currentDateString
    }
}
