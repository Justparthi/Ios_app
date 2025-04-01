//
//  WeightTrackerModel.swift
//  Physiotherapy
//
//  Created by Priya Dube on 29/06/23.
//

import Foundation
import Firebase

@MainActor
class WeightTrackerModel: ObservableObject {
    
    let commomFunc = CommomFunctions()
    let db = Firestore.firestore()
  
    func createWeightTrackerSubCollection(userID: String, userWeight: String,highestWeight: String,lowestWeight: String, dateSubmitted: String) {
        
        if let user = try? AuthenticationManager.shared.getAuthenticatedUser() {
            let documentRef = db.collection("Users").document(user.uid)
            
            documentRef.collection("WeightTracker").addDocument(data:
                                                                    ["userID": userID,
                                                                     "userWeight": userWeight,
                                                                     "HighestWeight": highestWeight,
                                                                     "LowestWeight": lowestWeight,
                                                                     "dateSubmitted": dateSubmitted]) { error in
                if let error {
                    print("Error creating subcollection: \(error)")
                } else {
                    print("Subcollection created successfully.")
                }
            }
        }else {
            print("User isn't authenticated.")
        }
        
    }
    
    func fetchData() {
        
//        let collectionRef = db.collection("WeightTracker")
//
//            collectionRef.getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching documents: \(error)")
//                    return
//                }
//
//                guard let documents = snapshot?.documents else {
//                    print("No documents found.")
//                    return
//                }
//
//                // Map the fetched data to Swift objects
//                data = documents.compactMap { document in
//                    try? document.data(as: YourDataModel.self)
//                }
//            }
        }
    
}
