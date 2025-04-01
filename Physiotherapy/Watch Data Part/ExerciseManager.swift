//
//  ExerciseManager.swift
//  Physiotherapy
//
//  Created by chirag arora on 31/12/23.
//

import WatchConnectivity
import FirebaseFirestore

class ExerciseManager {
    private let db = Firestore.firestore()

    func fetchExercisesFromFirestore(completion: @escaping ([ExerciseModel]) -> Void) {
        // Reference to the "exercises" collection in Firestore
        let exercisesCollection = db.collection("exercises")

        // Fetch exercises from Firestore
        exercisesCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching exercises: \(error.localizedDescription)")
                completion([])
                return
            }

            // Parse the documents into ExerciseModel objects
            let exercises = querySnapshot?.documents.compactMap { document -> ExerciseModel? in
                let data = document.data()
                // Assuming ExerciseModel has properties "title" and "duration"
                if let title = data["title"] as? String,
                   let duration = data["duration"] as? Int {
                    return ExerciseModel(title: title, duration: duration)
                } else {
                    return nil
                }
            } ?? []

            // Call the completion handler with the fetched exercises
            completion(exercises)

            // Move the following line inside the closure to fix the misplaced call
            self.sendExercisesToWatch(exercises)
        }
    }

    func sendExercisesToWatch(_ exercises: [ExerciseModel]) {
        if WCSession.default.isReachable {
            do {
                // Serialize exercises to Data
                let data = try JSONEncoder().encode(exercises)

                // Send data to the watchOS app
                WCSession.default.sendMessage(["exercises": data], replyHandler: nil, errorHandler: { error in
                    print("Error sending exercises to watch: \(error.localizedDescription)")
                })
            } catch {
                print("Error encoding exercises: \(error.localizedDescription)")
            }
        }
    }
}

// Example of ExerciseModel struct, adapt this to match your actual data model
struct ExerciseModel: Codable {
    var title: String
    var duration: Int
    // Add other properties as needed
}
