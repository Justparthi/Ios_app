//
//  WeightTrackerInfo.swift
//  Physiotherapy
//
//  Created by Priya Dube on 05/07/23.
//

import Foundation

struct WeightTrackerInfo: Identifiable{
    
    
    var id: ObjectIdentifier
    
    var userID: String = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var userWeight: String = ""
    var dateSubmitted: String = ""
}
