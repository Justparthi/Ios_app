//
//  FirestoreDatabase.swift
//  Physiotherapy
//
//  Created by Yash Patil on 12/10/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI


class FirestoreDatabase {
    
    static let shared = FirestoreDatabase()
    
    let db = Firestore.firestore()
    
    func addData() {
        
        let data: [String: Any] = ["email" : "AdminYash@gmail.com",
                                   "password": "Yashdeep123"]
        
        db.collection("Admins").document("customDoc").setData(data)
    }
    
    func getDocuments() {
        
    }
}
