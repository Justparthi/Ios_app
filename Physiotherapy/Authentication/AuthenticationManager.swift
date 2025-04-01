//
//  AuthenticationManager.swift
//  Physiotherapy
//
//  Created by Priya Dube on 22/06/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct authDataResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthenticationManager {
        
    //creating a singleton named "shared" for Authentication. Only instance of this calss in whole app.
    static let shared = AuthenticationManager()
    private init() {}
    
    @discardableResult
    func getAuthenticatedUser() throws -> authDataResultModel {

        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return authDataResultModel(user: user)
    }
    
    @discardableResult
    func createEmailPassword(email: String, password: String)async throws -> authDataResultModel {
        let emailPwdResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return authDataResultModel(user: emailPwdResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> authDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}


