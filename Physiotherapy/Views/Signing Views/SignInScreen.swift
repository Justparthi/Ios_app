//
//  SignInScreen.swift
//  Physiotherapy
//
//  Created by Priya Dube on 28/06/23.
//

import SwiftUI
import Firebase


struct SignInScreen: View {
    
    @State private var isLoggedIn = false
    @State var isVerifiedCheck: Bool
    // Firebase Authentication : Email/Password
    @StateObject private var viewModel = SignUPViewModel()
    @State private var showForgotPasswordView = false
    @State private var showingAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var appColor : Color = Color("CustomColor")
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")

    var body: some View {
        NavigationView{
            GeometryReader { geo in
                ZStack {
                    Spacer()
                    VStack{
                        Text("Sign In")
                            .bold()
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                            .font(.system(size: 40))
                        
                        /*
                         Email field.
                         */
                        
                        TextField(text: $viewModel.userEmail) {
                            Text("Email")
                                .foregroundStyle(
                                    Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)
                                ).bold()
                        }.frame(width: 350, height: 50)
                            .padding(.leading, 21)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29)
                                    ).frame(width: 350, height: 50)
                            }.padding(.top, 15)
                            .foregroundStyle(.white)
                            .autocapitalization(.none)
                        
                        /*
                         Password field.
                         */
                        
                        SecureField(text: $viewModel.userPassword) {
                            Text("Password")
                                .foregroundStyle(
                                    Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)
                                ).bold()
                        }.frame(width: 350, height: 50)
                            .padding(.leading, 21)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29)
                                    ).frame(width: 350, height: 50)
                            }.padding(.top, 15)
                            .foregroundStyle(.white)
                            .autocapitalization(.none)
                        
                        HStack {
                            Spacer()
                            Button {
                                showForgotPasswordView = true
                            } label: {
                                Text("Forgot password")
                                    .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                                    .padding(.top, 15)
                            }
                        }.padding(.trailing)
                        
                        ZStack {
                            Button(action: {
                                logIn()  // Call the log in function
                            }) {
                                Text("Log In")
                                    .foregroundStyle(.white)  // Set text color
                                    .frame(width: 300, height: 50)  // Match frame size with the "Next" button
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("newOrange")))  // Use the same background style
                                    .cornerRadius(10)  // Apply rounded corners
                            }
                            .fullScreenCover(isPresented: $isLoggedIn) {
                                // The logic to decide which view to present based on the condition
                                if getIsUserVerified() {
                                    Physiotherapy(selectedTab: 0)  // Show Physiotherapy view if verified
                                } else {
                                    ConnectToTrainer(isFromSignin: true)  // Otherwise, show the trainer connection screen
                                }
                            }
                            .padding(.top)
                        }
                        
                        Text("Dont have an account?")
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                            .padding(.top, 15)
                        NavigationLink(destination: SignUpForm(padding: 0.0)) {
                            Text("Register Here")
                                .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                                .underline()
                            
                        }
                        
                    }
                    .padding()
                    if showForgotPasswordView {
                        brownColor.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showForgotPasswordView = false
                                }
                            }
                        
                        VStack {
                            Spacer()
                            ForgotPasswordView()
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut)
                                .frame(width: UIScreen.main.bounds.width, height: 270)
                                .background(Color.orange)
                                .cornerRadius(16)
                        }
                        .padding()
                    }
                    
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
                
            }.alert(alertTitle, isPresented: self.$showingAlert) {
                
            } message: {
                Text(alertMessage)
            }

        }
        
    }
    func getIsUserVerified() -> Bool{
        let userid = Auth.auth().currentUser?.uid ?? ""
        let db = Firestore.firestore()
        db.collection("Users").whereField("userId", isEqualTo: userid).getDocuments() { snapshot, _ in
            if let snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    isVerifiedCheck = data["verified"] as? Bool ?? false
                }
            }
        }
        return isVerifiedCheck
    }

}

#Preview {
    SignInScreen(isVerifiedCheck: false)
}


extension SignInScreen {
    
    func logIn() {
        guard !viewModel.userEmail.isEmpty,
              !viewModel.userPassword.isEmpty else {
            showingAlert = true
            alertTitle = "Invalid Email"
            alertMessage = "Please enter valid Email"
            return }
        
        Task {
            do {
                try await viewModel.signIn(userEmail: viewModel.userEmail, userPassword: viewModel.userPassword)
                isLoggedIn = true
                
            }catch let error {
                showingAlert = true
                alertMessage = "Invalid username or password"
                print("Error signing in: \(error.localizedDescription)")
            }
        }
    }
}
