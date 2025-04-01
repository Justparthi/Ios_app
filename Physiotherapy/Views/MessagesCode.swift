//
//  MessagesCode.swift
//  Physiotherapy
//
//  Created by Yash Patil on 11/10/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

enum Users {
    case user
    case physiotherapist
}

struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timeStamp = "timestamp"
    static let isImage = "isImage"
}

struct ChatMessage: Identifiable {
    var id = UUID()
    let text: String
    var isImage: Bool
    let person: Users
    
    init(
        data: [String: Any],
        person: Users,
        isImage: Bool = false
    ) {
        self.text = data[FirebaseConstants.text] as! String 
        self.person = person
        self.isImage = isImage
    }
}

import FirebaseFirestore

@MainActor
@Observable
class MessageViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    let messageDB = Firestore.firestore().collection("messages")
    
    var userId = ""
    var physioId = ""
    var userText: String = ""
    var physioText: String = ""
    var chats: [ChatMessage] = []
    

    func checkConnectionToTrainer(completion: @escaping (Bool) -> Void) {
            guard let userId = Auth.auth().currentUser?.uid else {
                completion(false)
                return
            }

            let userRef = db.collection("Users").document(userId)

            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let referralCode = document["referralCode"] as? String, !referralCode.isEmpty {
                        completion(true) // User is connected to a trainer
                    } else {
                        completion(false) // User is not connected to a trainer
                    }
                } else {
                    print("Document does not exist")
                    completion(false)
                }
            }
        }
    
    func performFetching() {
        chats.removeAll()
        Task {
            await getData()
            fetchMessages(from: physioId, to: userId)
        }
    }
    
    func userTexted() {
        guard !userText.isEmpty else { return }
        send(message: userText)
        userText = ""
    }
    
    func fetchMessages(from physioId: String, to userId: String) {
        // Ensure physioId and userId are valid before proceeding
        guard !physioId.isEmpty, !userId.isEmpty else {
            print("Invalid physioId or userId")
            return
        }

        messageDB
            .document(physioId) // Physio Doc
            .collection(userId) // User collec
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snapshot, _ in
                snapshot?.documentChanges.forEach { change in
                    if change.type == .added {
                        let data = change.document.data()
                        guard
                            let self = self
                        else { return }
                        
                        let id = data["fromId"] as! String
                        
                        let isUser = (id == self.userId)
                        
                        let isImage = data["isImage"] as? Bool
                        
                        let chatMessage: ChatMessage = ChatMessage(
                            data: data,
                            person: isUser ? .user : .physiotherapist,
                            isImage: (isImage != nil) ? isImage! : false
                        )
                        
                        self.chats.append(chatMessage)
                    }
                }
            }
    }

    
    func send(message: String)  {
        let document =
        messageDB
            .document(physioId)
            .collection(userId)
            .document()
        
        let messageData: [String: Any] = [
            FirebaseConstants.fromId : userId,
            FirebaseConstants.text: message,
            FirebaseConstants.toId: physioId,
            "timestamp": Timestamp()
        ]
        
        document.setData(messageData)
    }
    
    func sendPhotoImage(path: String)  {
        let document =
        messageDB
            .document(physioId)
            .collection(userId)
            .document()
        
        let messageData: [String: Any] = [
            FirebaseConstants.fromId : userId,
            FirebaseConstants.isImage: true,
            FirebaseConstants.text: path,
            FirebaseConstants.timeStamp: Timestamp(),
            FirebaseConstants.toId: physioId,
        ]
        
        document.setData(messageData)
    }
    
    func getData() async {
        
        if let user = try? AuthenticationManager.shared.getAuthenticatedUser() {
            self.userId = user.uid // Set UserId to the model
            
            let snapshot = try? await db.collection("Users").whereField("userId", isEqualTo: user.uid).getDocuments()
            
            if let snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    if let code = data["referralCode"] as? String {
                        await self.getPhysioId(code: code)
                    } else {
                        print("Failed to retrieve referral Code")
                    }
                }
            }
        }
    }
    
    func getPhysioId(code: String) async {
        
        let snapshot = try? await db.collection("physiotherapist").whereField("referralCode", isEqualTo: code).getDocuments()
        if let snapshot {
            for doc in snapshot.documents {
                let data = doc.data()
                let id = data["physiotherapistId"] as! String
                self.physioId = id // Sets physio id
            }
        }
    }
}
