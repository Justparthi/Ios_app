//
//  ExerciseTrackerInfo.swift
//  Physiotherapy
//
//  Created by Priya Dube on 10/07/23.
//

import Foundation

struct ExerciseTrackerInfo: Identifiable{
    
    
    var id: ObjectIdentifier
    
    var userID: String = UserDefaults.standard.string(forKey: "UserID") ?? ""

    var time: String = ""
    var reps: String = ""
    var exercises: [String] = []
    var musclesInvolved: [String] = []
    var goalAchieved: String = ""
    var calories: String = ""
    var videoLink: String = ""
    var description: String = ""
    var like: Bool = false

    var dateSubmitted: String = ""
    
}
