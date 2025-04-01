//
//  File.swift
//  Utilities
//
//  Created by Yash Patil on 06/11/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage
import Alamofire

struct Exercise: Decodable {
    let exercise_type: String
    let Accuracy: String
    let muscles_involved: [String]
    let skeleton_image: String
}

class Utilities {
    
    static let shared = Utilities()
    
    private let firestore = Firestore.firestore().collection("Form Check Tool")
    private var cancellables = Set<AnyCancellable>()
    
    // Process recorded video using Alamofire
    func processRecordedVideo(at videoUrl: URL) {
        let url = "https://ttl-18h-25jan-4264hmak2a-em.a.run.app/output_video"
        let videoFileName = "HowToDoAGluteBridge"
        let videoFileExtension = "mp4"
        
        guard FileManager.default.fileExists(atPath: videoUrl.path) else {
            print("Video file not found at URL.")
            return
        }
        
        // Alamofire upload for video
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(videoUrl, withName: "file", fileName: "\(videoFileName).\(videoFileExtension)", mimeType: "video/mp4")
            },
            to: url
        )
        .responseDecodable(of: Exercise.self) { response in
            switch response.result {
            case .success(let exercise):
                print("Exercise received: \(exercise)")

                // Prepare data for Firestore
                let exerciseData: [String: Any] = [
                    "exercise_type": exercise.exercise_type,
                    "muscles_involved": exercise.muscles_involved,
                    "Accuracy": exercise.Accuracy,
                    "skeleton_image": exercise.skeleton_image,
                    "date": self.getCurrentDateandTime()
                ]
                
                // Store result in Firestore
                self.storeResultInFirestore(exerciseData)
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    // Store exercise result in Firestore
    func storeResultInFirestore(_ result: [String: Any]) {
        guard let user = Auth.auth().currentUser?.uid else { return }
        firestore.document(user).collection("results").addDocument(data: result) { error in
            if let error = error {
                print("Error adding result to Firestore: \(error)")
            } else {
                print("Document added to Firestore")
            }
        }
    }
    
    // Store video to Firebase Storage
    func storeVideoToStorage(_ videoURL: URL?) {
        guard let videoURL = videoURL else {
            print("Error: videoURL is nil")
            return
        }
        let storageRef = Storage.storage().reference()
        let videoName = UUID().uuidString
        let videoRef = storageRef.child("Form Check Tool/\(videoName).mp4")
        
        videoRef.putFile(from: videoURL, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading video to storage: \(error)")
            } else {
                print("Successfully uploaded video to storage")
            }
        }
    }
    
    // Store exercise data in Firestore
    func storeInFirestore(exercise: Exercise) {
        guard let user = Auth.auth().currentUser else { return }
        
        let exerciseData: [String: Any] = [
            "exercise_type": exercise.exercise_type,
            "muscles_involved": exercise.muscles_involved,
            "Accuracy": exercise.Accuracy,
            "skeleton_image": exercise.skeleton_image
        ]
        
        firestore.document(user.uid).setData(exerciseData) { error in
            if let error = error {
                print("Error storing exercise data in Firestore: \(error)")
            } else {
                print("Exercise data stored successfully.")
            }
        }
    }
    
    // Fetch exercise data from Firestore
    func getExercise(_ completion: @escaping (Exercise?) -> ()) {
        // Sign-in process
        Auth.auth().signIn(withEmail: "niketbeldar2@gmail.com", password: "NiketBeldar2") { result, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let user = result?.user else {
                print("User not found")
                completion(nil)
                return
            }
            
            // Fetch exercise data from Firestore
            self.firestore.document(user.uid).getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching exercise: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let snapshot = snapshot {
                    do {
                        let data = try snapshot.data(as: Exercise.self)
                        print("Exercise fetched")
                        completion(data)
                    } catch let error {
                        print("Error decoding exercise: \(error)")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    // Helper function to get the current date and time
    private func getCurrentDateandTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}
