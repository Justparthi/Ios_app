//
//  SignUpViewModel.swift
//  Physiotherapy
//
//  Created by Priya Dube on 28/06/23.//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

//Firebase Sign In with Email/ Password
@MainActor
@Observable
final class SignUPViewModel: ObservableObject {
    
    
    let db = Firestore.firestore()
    var commonFunc = CommomFunctions()
    var isSignedIn = false
    var showAlertMessage = false
    
    var showingAlert = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    var errorMessage: String = ""
    
    var userData = [UserSignUpInfo]()
    var userEmail = ""
    var userPassword = ""
    var reEnterPassword = ""
    var userID: String = ""
    var userGender: String = "Male"
    var userHeightInCm: String = ""
    var userWeight: String = ""
    var userDOB: String = ""
    var userName: String = "Shelly Stan"
    var userPhoneNumber: String = ""
    var userProfilePhotoPath: String = ""
    var accCreated: String = ""
    var profileImage: UIImage?
    var profileImagePath: String = ""
    var referralCode: String = ""
    var verified: Bool = false
    //Document id reference
    var documentID: String = ""
    var user: User? = nil
    func signIn(userEmail: String, userPassword: String) async throws {
        // Create a Firebase Auth instance.
        let auth = Auth.auth()
        
        // Sign in the user with their email and password.
        
        try await auth.signIn(withEmail: userEmail, password: userPassword)
        
        let userId = Auth.auth().currentUser?.uid
        UserDefaults.standard.set(self.userEmail, forKey: "userEmail")
        UserDefaults.standard.set(userId, forKey: "userID")
        self.isSignedIn = true
        print("SignedIn Successfully")
        
    }
    
    
    //    func getSignedInUserInfo()
    //    {
    //        guard let user = Auth.auth().currentUser else { return }
    //    }
    
    
    
    //Sign up with email and pwd
    //    func SignUp(){
    //        guard !userEmail.isEmpty, !userPassword.isEmpty else{
    //            print("No email or password found")
    //            return
    //        }
    //        Task{
    //            do{
    //                let returnedUserData = try await AuthenticationManager.shared.createEmailPassword(
    //                    email: userEmail, password: userPassword)
    //                print("Success")
    //            }catch{
    //                print("Error : \(error)")
    //            }
    //        }
    //    }
    
    
    //Sign up with user information
    func SigningUp(completion: @escaping (Bool) -> Void) {
        guard !userEmail.isEmpty, !userPassword.isEmpty else {
            print("No email or password found")
            showingAlert = true
            alertTitle = "No email or password found"
            completion(false) // Call completion with failure
            return
        }
        
        Task {
            do {
                try await AuthenticationManager.shared.createEmailPassword(email: userEmail, password: userPassword)
                
                let userId = Auth.auth().currentUser?.uid
                UserDefaults.standard.set(self.userEmail, forKey: "userEmail")
                UserDefaults.standard.set(userId, forKey: "userID")
                UserDefaults.standard.set(commonFunc.getCurrentDate(), forKey: "accCreated")
                
                print("Before Signing In we have data : ID: \(userID), email: \(userEmail), pwd: \(userPassword), name: \(userName), phone: \(userPhoneNumber), DOB: \(userDOB), Height: \(userHeightInCm), weight: \(userWeight), acc Created : \(accCreated) ")
                
                db.collection("Users").document(userId!).setData([
                    "userId": userId ?? "",
                    "userEmail": userEmail,
                    "userPassword": userPassword,
                    "userGender": userGender,
                    "userHeightInCm": userHeightInCm,
                    "userWeight": userWeight,
                    "referralCode": referralCode,
                    "verified": verified,
                    "userName": userName,
                    "userPhoneNumber": userPhoneNumber,
                    "userDOB": userDOB,
                    "accCreated": commonFunc.getCurrentDate(),
                    "userProfilePhoto": userProfilePhotoPath
                ]) { error in
                    if let error = error {
                        print("Error saving user data: \(error.localizedDescription)")
                        self.isSignedIn = false
                        completion(false) // Call completion with failure
                    } else {
                        self.isSignedIn = true
                        self.documentID = userId!
                        UserDefaults.standard.set(self.documentID, forKey: "documentID")
                        print("my Document Id is : \(self.documentID)")
                        print("Success")
                        completion(true) // Call completion with success
                    }
                }
                
            } catch {
                print("Error : \(error)")
                showingAlert = true
                alertTitle = "Error In Signing up"
                alertMessage = error.localizedDescription
                print(alertMessage)
                completion(false) // Call completion with failure
            }
        }
    }
    
    
    
    func signOut() throws{
        try Auth.auth().signOut()
        //For signing out from other screens use:
        //AuthenticationManager.shared.signOut()
        
        UserDefaults.standard.set("", forKey: "userEmail")
        UserDefaults.standard.set("", forKey: "userID")
        UserDefaults.standard.set("", forKey: "accCreated")
        UserDefaults.standard.set("", forKey: "userHeightInCm")
        UserDefaults.standard.set("", forKey: "userWeight")
    }
    
    func updateUserInfo(newUsername: String, newEmail: String, newPhoneNumber: String, newPassword: String, newProfilePhotoPath: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            // Handle the case where the user is not authenticated
            return
        }

        let userRef = db.collection("Users").document(userId)

        do {
            try await userRef.updateData([
                "userName": newUsername,
                "userEmail": newEmail,
                "userPhoneNumber": newPhoneNumber,
                "userPassword": newPassword,
                "userProfilePhoto": newProfilePhotoPath
                // Add other fields you want to update
            ])

            // Update user details in UserDefaults
            UserDefaults.standard.set(newUsername, forKey: "userName")
            UserDefaults.standard.set(newEmail, forKey: "userEmail")
            UserDefaults.standard.set(newPhoneNumber, forKey: "userPhoneNumber")
            UserDefaults.standard.set(newPassword, forKey: "userPassword")
            UserDefaults.standard.set(newProfilePhotoPath, forKey: "userProfilePhoto")
            

            // Update user details in the ViewModel
            self.userName = newUsername
            self.userEmail = newEmail
            self.userPhoneNumber = newPhoneNumber
            self.userPassword = newPassword
            self.profileImagePath = newProfilePhotoPath
            
            // Add other fields you want to update

            print("User details updated successfully")
        } catch {
            // Handle the error
            print("Error updating user details: \(error.localizedDescription)")
            throw error
        }
    }

    
}
