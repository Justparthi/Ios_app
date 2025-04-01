//
//  OnboardingS1.swift
//  Physiotherapy
//
//  Created by Shagun on 09/05/23.
//

import SwiftUI

struct OnboardingS1: View {
    
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    // To check whether user is already signedIn, we have created an instance of SignUpViewModel to access authentication
    @StateObject private var viewModel = SignUPViewModel()
    @State private var isSignedIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack{
                    Text("Vigour Fit")
                        .font(.system(size: 55))
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(.bottom,70)
                        .foregroundStyle(Color("newOrange"))
                    
                    Text("You are ready to go!")
                        .font(.system(size: 34))
                        .padding(.bottom,30)
                        .bold()
                        .foregroundStyle(Color("newOrange"))
                    
                    Text("""
Let’s directly move onto the app to explore all the new and unique features!
""")
                        .multilineTextAlignment(.center)
                        .frame(width: 300)
                        .padding(.bottom,40)
                        .foregroundStyle(Color.white)
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Lets Go")
                            .foregroundStyle(.white)  // Change to foregroundColor for text color
                            .frame(width: 300, height: 50)  // Set frame for the button
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("newOrange")))
                            .cornerRadius(10)  // Ensure the corner radius is applied to the text background
                    }
                    .padding(.bottom, 40)
                }.padding(.top,200)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
//            Checking whether user is signedIn or not. If signedIn, then show dashboard
            .onAppear {
                do {
                     try AuthenticationManager.shared.getAuthenticatedUser()
                     self.isSignedIn = true
                }catch let error {
                    print("Error authenticating: \(error.localizedDescription)")
                }
            }
            .background{
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
            .fullScreenCover(isPresented: $isSignedIn) {
                    // Home Screen
                    Physiotherapy(selectedTab: 0)
                }
            }
        }
    }

#Preview {
    OnboardingS1()

}

