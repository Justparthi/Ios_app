//
//  ResetPasswordView.swift
//  Physiotherapy
//
//  Created by george kaimoottil on 12/12/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ResetPasswordView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isResetPasswordSent: Bool = false
    @State private var errorMessage: String?
    @State private var isProfileViewPresented = false
    @State private var isResetPopupBoxShown = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack{
                    VStack {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.orange)
                        //                            .padding(8)
                            .offset(x:-150)
                            .onTapGesture {
                                isProfileViewPresented = true
                                print("Close button tapped")
                            }
                        
                        Text("Reset Password")
                            .bold()
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                            .font(.system(size: 35))
                            .padding(.top, 80)
                        
                        Text("Create a new password and type\nthe new password twice")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                            .font(.system(size: 20))
                            .padding(.top, 3)
                        
                        SecureField(text: self.$newPassword){
                            Text("Enter New Password")
                                .foregroundStyle(
                                    Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)
                                ).bold()
                        }
                        .frame(width: 350, height: 50)
                        .padding(.leading, 21)
                        .background {
                            RoundedRectangle(cornerRadius: 40)
                                .fill(
                                    Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29)
                                ).frame(width: 350, height: 50)
                        }.padding(.top, 15)
                        
                        /*
                         Re-enter Password field.
                         */
                        
                        SecureField(text: self.$confirmPassword) {
                            Text("Re-enter New Password")
                                .foregroundStyle(Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)
                                ).bold()
                        }
                        .frame(width: 350, height: 50)
                        .padding(.leading, 21)
                        .background {
                            RoundedRectangle(cornerRadius: 40)
                                .fill(
                                    Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29)
                                ).frame(width: 350, height: 50)
                        }.padding(.top, 15)
                        
                        Button("Reset") {
                            isResetPopupBoxShown = true
                            resetPassword() }
                        .frame(width: 180, height: 60)
                        .bold()
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                        }.padding(.top)
                        
                        Spacer()
                        
                    }.frame(width: geo.size.width, height: geo.size.height)
                        .background {
                            ZStack {
                                Color(red: 0.13, green: 0.13, blue: 0.13)
                                    .ignoresSafeArea(.all)
                                
                                Ellipse()
                                    .foregroundColor(.clear)
                                    .frame(width: 523, height: 563)
                                    .background(Color(red: 1, green: 0.74, blue: 0.51).opacity(0.39))
                                    .blur(radius: 700)
                            }
                        }.aspectRatio(contentMode: .fit)
                    //PopUp Box Shown
                    if isResetPopupBoxShown {
                        ResetPasswordPopUpBox()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isProfileViewPresented) {
            Physiotherapy(selectedTab: 4)}
    }
    private func resetPassword() {
        Task {
            await performPasswordReset()
        }
    }
    private func performPasswordReset() async {
        guard newPassword == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        guard let userId = Auth.auth().currentUser?.uid else {
            // Handle the case where the user is not authenticated
            return
        }
        
        let userRef = Firestore.firestore().collection("Users").document(userId)
        
        do {
            try await userRef.updateData([
                "userPassword": newPassword
                // Add other fields you want to update
            ])
            
            UserDefaults.standard.set(newPassword, forKey: "userPassword")
            print("User details updated successfully")
        } catch {
            // Handle the error
            print("Error updating user details: \(error.localizedDescription)")
        }
    }
}


struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct ResetPasswordPopUpBox: View {
    @State private var isProfileViewPresented = false
    
    var body: some View {
        ZStack{
            ResetPasswordView()
                .blur(radius: 10)
            VStack{
                Image(systemName: "checkmark.circle.fill")
                    .font(.custom("Raleway", size: 50))
                    .foregroundStyle(.white)
                Text("Password has been Reset Successfully")
                    .font(.custom("Raleway", size: 24))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(uiColor: UIColor(hex: "D9D9D9", alpha: 1.0)!))
            }
            .frame(width: 250, height: 230)
        }
        .fullScreenCover(isPresented: $isProfileViewPresented) {
            Physiotherapy(selectedTab: 4)
        }
        .onAppear{
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                isProfileViewPresented = true
            }
        }
    }
}

#Preview {
    ResetPasswordPopUpBox()
}

#Preview {
    ResetPasswordView()
}
