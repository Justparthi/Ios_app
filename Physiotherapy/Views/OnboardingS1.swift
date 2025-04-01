//
//  OnboardingS1.swift
//  Physiotherapy
//
//  Created by Shagun on 09/05/23.
//

import SwiftUI
import FirebaseAuth

struct OnboardingS1: View {
    
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    // To check whether user is already signedIn, we have created an instance of SignUpViewModel to access authentication
    @StateObject private var viewModel = SignUPViewModel()
    @State private var isSignedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                
                VStack{
                    Text("Trainer App").font(.system(size: 55))
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.center).bold()
                        .padding(.bottom,70)
                        .foregroundStyle(Color("newOrange"))
                    
                    Text("You are ready to go!").font(.system(size: 34)).padding(.bottom,30).bold()
                        .foregroundStyle(Color("newOrange"))
                    
                    Text("""
Let’s directly move onto the app to explore all the new and unique features!
""")
                        .multilineTextAlignment(.center)
                        .frame(width: 300)
                        .padding(.bottom,40)
                        .foregroundColor(Color.white)
                    
                    NavigationLink(destination: RegisterView()) {
                        
                        Text("Register Now")
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 300, height: 50)
                                    .foregroundColor(Color("newOrange")))
                        
                    }.padding(.bottom,40)
                    //NavigationLink(destination: SignInView())
                    NavigationLink(destination: SignInScreen(isVerifiedCheck: false))
                    {
                        Text("Already have any account?  Sign In")
                            .foregroundStyle(Color("newOrange"))
                    }
                    .padding(.bottom,30)
                }.padding(.top,200)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
            
            //Checking whether user is signedIn or not. If signedIn, then show dashboard
            .onAppear {
                do {
                    let variable=try AuthenticationManager.shared.getAuthenticatedUser()
                    
                    if !variable.email!.isEmpty{
                        
                        self.isSignedIn = true
                    }
                }catch let error {
                    print("Error authenticating: \(error.localizedDescription)")
                }
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
            .fullScreenCover(isPresented: $isSignedIn) {
                NavigationStack {
                    // Home Screen
                    Physiotherapy(selectedTab: 0)
                }
            }
        }
    }
}

#Preview {
    OnboardingS1()

}

