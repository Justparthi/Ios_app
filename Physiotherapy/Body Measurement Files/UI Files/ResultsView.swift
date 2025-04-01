//
//  ResultsVie.swift
//  Physiotherapy
//
//  Created by Yash Patil on 26/10/23.
//

import SwiftUI

struct Results {
    let height, waist, leg, shoulder, arms: Double
}

struct ResultsView: View {
    let result: Results
    var orangeColor: Color = Color("orangeColor")
    @State private var isProfileViewPresented = false
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode  // This will allow us to dismiss the current view

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    // Header with Info Button
                    HStack {
                        Spacer()
                        Text("Results")
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                            .font(.custom("cabin", size: 40))
                        Spacer()
                        Button(action: {
                            self.showingAlert = true
                        }) {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                        .padding(.trailing, 20)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Information"),
                              message: Text("Add requirements here"),
                              dismissButton: .default(Text("OK")))
                    }
                    
                    // Body Content with Results
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Height")
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFFFFF", alpha: 1.0)!))
                            .font(.custom("cabin", size: 18))
                        
                        Text("\(String(format: "%.2f", result.height * 100)) cm")
                            .bold()
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                            .font(.custom("cabin", size: 28))

                        Text("Waist length")
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFFFFF", alpha: 1.0)!))
                            .font(.custom("cabin", size: 18))
                        
                        Text("\(String(format: "%.2f", result.waist * 100)) cm")
                            .bold()
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                            .font(.custom("cabin", size: 28))
                        
                        Text("Leg length")
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFFFFF", alpha: 1.0)!))
                            .font(.custom("cabin", size: 18))
                        
                        Text("\(String(format: "%.2f", result.leg * 100)) cm")
                            .bold()
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                            .font(.custom("cabin", size: 28))

                        Text("Shoulder length")
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFFFFF", alpha: 1.0)!))
                            .font(.custom("cabin", size: 18))
                        
                        Text("\(String(format: "%.2f", result.shoulder * 100)) cm")
                            .bold()
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                            .font(.custom("cabin", size: 28))

                        Text("Arms Length")
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFFFFF", alpha: 1.0)!))
                            .font(.custom("cabin", size: 18))
                        
                        Text("\(String(format: "%.2f", result.arms * 100)) cm")
                            .bold()
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                            .font(.custom("cabin", size: 28))
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Done Button
                    Button {
                        isProfileViewPresented = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                                .frame(width: 350, height: 50)
                                .shadow(radius: 6)
                                .padding(.top, 15)
                            Text("Done")
                                .font(.system(size: 24))
                                .padding(.top)
                                .foregroundStyle(.white)
                        }
                    }

                    // Recapture Button (Navigating back to ViewController)
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()  // Dismiss the current view, which takes us back to the previous view (likely your ViewController)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 350, height: 50)
                                .shadow(radius: 6)
                                .padding(.top, 15)
                            Text("Recapture")
                                .font(.system(size: 24))
                                .padding(.top)
                                .foregroundStyle(.black)
                        }
                    }
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
                .aspectRatio(contentMode: .fit)
            }
        }
        .fullScreenCover(isPresented: $isProfileViewPresented) {
            Physiotherapy(selectedTab: 4)
        }
    }
}
