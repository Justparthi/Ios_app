//
//  SecondView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 15/10/23.
//

import SwiftUI

struct RegisterView: View {
    // Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    @State private var isPresentingSecondView = false
    @State private var isPresentingThirdView = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Track your progress")
                    .font(.system(size: 40))
                    .bold()
                    .foregroundStyle(Color("newOrange"))
                    .padding(.bottom, 50)
                
                Image("progressor")
                    .cornerRadius(40)
                    .padding(.bottom)
                
                Text("Track your daily, monthly, and yearly progress and get stronger and more flexible with the routine in no time.")
                    .font(.system(size: 20))
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 20)
                
                ZStack {
                    NavigationLink(destination: ThirdView()) {
                        Text("Next")
                            .foregroundStyle(.white)
                            .frame(width: 300, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("newOrange")))
                            .cornerRadius(10)
                    }
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Skip") {
                        FourthView()
                    }
                    .foregroundStyle(Color.blue)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RegisterView()
}
