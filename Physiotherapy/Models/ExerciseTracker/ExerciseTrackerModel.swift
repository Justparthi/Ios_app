//
//  ExerciseTrackerModel.swift
//  Physiotherapy
//
//  Created by Priya Dube on 10/07/23.
//

import Foundation

import Firebase

@MainActor
class ExerciseTrackerModel: ObservableObject {
    
    let commomFunc = CommomFunctions()
    let db = Firestore.firestore()
  
    func createExerciseTrackerSubCollection (userID: String, userWeight: String, dateSubmitted: String)
    {
        let documentID = UserDefaults.standard.string(forKey: "documentID") // ID of the parent document
      
        let subcollectionName = "ExerciseTracker" // Name of the subcollection
        
        let collectionRef = db.collection("Users")
        
        let documentRef = collectionRef.document(documentID!)
        
        documentRef.collection(subcollectionName).addDocument(data:
                                                                ["userID": userID,
                                                                 "userWeight": userWeight,
                                                                 "dateSubmitted": dateSubmitted])
        { error in
            if let error = error {
                print("Error creating subcollection: \(error)")
            } else {
                print("Subcollection created successfully.")
            }
        }
    }
    
    func getWeightData() {
        
        let _ = db.collection("WeightTracker")
        
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
