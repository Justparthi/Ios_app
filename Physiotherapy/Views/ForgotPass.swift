//
//  ForgotPass.swift
//  Physiotherapy
//
//  Created by george kaimoottil on 12/12/23.
//

import SwiftUI
import FirebaseAuth

import SwiftUI
import Firebase

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToLogin = false
    

    var body: some View {
        GeometryReader{ geo in
            VStack {
                //            Spacer()
                Capsule()
                    .foregroundColor(Color(.systemGray5))
                    .frame(width: 48,height: 6)
                    .padding(.top,8)
                Text("Forgot Password")
                    .bold()
                    .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                    .font(.custom("cabin", size: 35))
                    .padding(.top, 80)
                
                TextField(text: self.$email) {
                    Text("Enter Email")
                        .foregroundStyle(
                            Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)
                        ).bold()
                }.frame(width: 350, height: 50)
                    .padding(.leading, 21)
                    .background {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(
                                Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29)
                            ).frame(width: 350, height: 50)
                    }.padding(.top, 40)
                    .foregroundStyle(.white)
                
                Button("Continue") {
                    sendPasswordReset()
                }
                .frame(width: 180, height: 60)
                .bold()
                .font(.system(size: 24))
                .foregroundStyle(.white)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                }.padding(.top)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")){
                            navigateToLogin = true
                        })
                    }
                
                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height)
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
            }
        }
            
        .padding(.bottom,75)
//        .navigationTitle("Forgot Password")
//        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $navigateToLogin) {
            SignInScreen(isVerifiedCheck: false)
        }
            
    }

    private func sendPasswordReset() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                showAlert = true
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                showAlert = true
                alertMessage = "Password reset email sent successfully. Check your email for instructions."
            }
        }
    }
}

struct LoginButtonStyle2: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

#Preview {
    ForgotPasswordView()
}

import SwiftUI

struct ForgotPasswordFields : View {
    
    @State var email:String = ""
    

    var body : some View {
        
        /*
            Email field.
         */
        
        TextField(text: self.$email) {
            Text("Enter Email")
                .foregroundStyle(
                    Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)
                ).bold()
        }.frame(width: 350, height: 50)
        .padding(.leading, 21)
        .background {
            RoundedRectangle(cornerRadius: 40)
                .fill(
                    Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29)
                ).frame(width: 350, height: 50)
        }.padding(.top, 40)
        .foregroundStyle(.white)
    }
}

struct ContinueButton : View {
    var body: some View {
        Button("Continue") {}
            .frame(width: 180, height: 60)
            .bold()
            .font(.system(size: 24))
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
            }.padding(.top)
    }
}

struct ForgotPasswordView1: View {
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                Text("Forgot Password")
                    .bold()
                    .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                    .font(.custom("cabin", size: 35))
                    .padding(.top, 80)
                
                ForgotPasswordFields()
                
                ContinueButton()
                
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
                
        }
    }
}

#Preview {
    ForgotPasswordView1()
}

