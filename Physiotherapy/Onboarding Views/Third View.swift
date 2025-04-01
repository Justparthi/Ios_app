//
//  Third View.swift
//  Physiotherapy
//
//  Created by Yash Patil on 15/10/23.
//

import SwiftUI

struct ThirdView: View {
    // Custom Colors
    var brownColor: Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")

    var body: some View {
        VStack {
            VStack {
                Text("Your daily workout companion")
                    .font(.system(size: 40))
                    .bold()
                    .foregroundStyle(Color("newOrange"))
                    .padding(.bottom, 50)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Image("companion")
                    .padding(.bottom)
                
                Text("Enhance your workout tracking experience with our in-app workout/exercise tracker.")
                    .font(.system(size: 20))
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: FourthView()) {
                    Text("Next")
                        .foregroundStyle(.white)
                        .frame(width: 300, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("newOrange")))
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                ZStack {
                    Color(red: 0.13, green: 0.13, blue: 0.13)
                        .ignoresSafeArea(.all)
                    
                    Ellipse()
                        .foregroundStyle(.clear)
                        .frame(width: 523, height: 563)
                        .background(Color(red: 1, green: 0.74, blue: 0.51).opacity(0.39))
                        .blur(radius: 700)
                }
            }
        }
    }
}



struct FourthView: View {
    // Custom Colors
    var brownColor: Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Text("Connect with Therapists")
                    .font(.system(size: 40))
                    .bold()
                    .foregroundStyle(Color("newOrange"))
                    .padding()
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 50)
                
                Image("therapist")
                    .padding(.bottom)
                
                Text("Expert therapists to help you improve your lifestyle.")
                    .font(.system(size: 20))
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: SignUpLandingScreen()) {
                    Text("Register Now")
                        .foregroundStyle(.white)
                        .frame(width: 300, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("newOrange")))
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: SignInScreen(isVerifiedCheck: false)) {
                    Text("Already have an account? Sign In")
                        .foregroundStyle(Color("newOrange"))
                }
                .padding(.bottom, 30)
                .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                ZStack {
                    Color(red: 0.13, green: 0.13, blue: 0.13)
                        .ignoresSafeArea(.all)
                    
                    Ellipse()
                        .foregroundStyle(.clear)
                        .frame(width: 523, height: 563)
                        .background(Color(red: 1, green: 0.74, blue: 0.51).opacity(0.39))
                        .blur(radius: 700)
                }
            }
        }
    }
}
