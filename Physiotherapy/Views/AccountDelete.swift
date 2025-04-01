//
//  AccountDelete.swift
//  Physiotherapy
//
//  Created by swayam on 23/03/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct AccountDelete: View {
    @State private var showOnboardingScreen = false
    var body: some View {
        NavigationView {
            
            VStack (spacing:15){
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                    VStack(alignment: .leading) {
                        Text("- Deleting your account will:")
                        Text("- Delete your account info and profile photo")
                    }
                    .foregroundStyle(.red)
                }
//                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 375, height: 50)
                        .foregroundStyle(.white)
                }
            
                Text("The action cannot be undone, kindly be cautious while deleting the account")
                    .foregroundStyle(.white)
//                Section {
                Button(action: {
                    deleteAccount()
                    
                    DispatchQueue.main.asyncAfter(deadline:.now()+1){
                        self.showOnboardingScreen=true
                    }
                }) {
                        Text("Delete my account")
                            .foregroundStyle(.red)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.white)
                                    .frame(width: 375, height: 50)
                            }
                    
                    .padding()
                }
                Spacer()
            }
            .fullScreenCover(isPresented: $showOnboardingScreen) {
                OnboardingS1()
            }
            .background{
                ZStack {
                    Color(red: 0.13, green: 0.13, blue: 0.13)
                        .ignoresSafeArea(.all)
                    
                    Ellipse()
                        .foregroundColor(.clear)
                        .frame(width: 523, height: 563)
                        .background(Color(red: 1, green: 0.74, blue: 0.51).opacity(0.39))
                        .blur(radius: 700)
                }
            }
        }
      
        
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            print("Currently no user.")
            return
        }
//        let userid = user.uid
//        let db = Firestore.firestore()
//        let ref = db.collection("Users").document(userid)
        user.delete
        { error in
            if let error = error {
                print("Error removing user from Database \(error.localizedDescription)")
                
            }
            else{
                print("Account deleted successfully")
            }
         //
            
        //
         
        }
       
                print("User data has been successfully deleted")

        
    }
}

#Preview {
    AccountDelete()
}
