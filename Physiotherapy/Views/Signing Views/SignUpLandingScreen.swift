//
//  SignUpLandingScreen.swift
//  Physiotherapy
//
//  Created by Priya Dube on 28/06/23.
//

import SwiftUI

enum SignUpLandingFlowRoute {
    case next
    case prev
}

struct SignUpLandingScreen: View {
    
    // Custom Colors
    var brownColor: Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    @State private var selectedHeight: Double = 5.0
    @State private var showingHeightSelection = false
    @State private var selectedWeight: Double = 70.0
    @State private var showingWeightSelection = false
    
    @State private var genderChosen = "Select Gender"
    @State private var isPresentingSecondView: Bool = false
    @State private var showAlert = false
    
    @StateObject private var viewModel = SignUPViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Let us know who you are?")
                    .font(.title)
                    .padding(.bottom, 40)
                    .bold()
                    .foregroundStyle(Color("newOrange"))
                
                Text("To give you a customized experience we need to know your details!")
                    .padding(.leading, 10)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                HStack {
                    Text("Gender:")
                        .bold()
                        .padding(.leading, 30)
                        .foregroundColor(Color("newOrange"))

                    Text(genderChosen)
                        .foregroundColor(Color("newOrange"))

                    Text("(Choose below)")
                        .foregroundColor(Color("newOrange"))

                    Spacer()
                }
                .padding(.top, 20)

                HStack(spacing: 20) {
                    GenderButton(gender: "Male", genderChosen: $genderChosen, viewModel: viewModel)
                    GenderButton(gender: "Female", genderChosen: $genderChosen, viewModel: viewModel)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
                
                heightWeightSelectionView(label: "Height (ft)", selection: $selectedHeight, showingSelection: $showingHeightSelection)
                heightWeightSelectionView(label: "Weight (lbs)", selection: $selectedWeight, showingSelection: $showingWeightSelection)

                continueButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Please select a gender before continuing."), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            resetValues()
        }
        .navigationDestination(isPresented: $isPresentingSecondView) {
            SignUpForm(padding:0)
        }
    }
    
    private var continueButton: some View {
        Button(action: {
            if genderChosen == "Select Gender" {
                showAlert = true
            } else {
                saveUserData()
                isPresentingSecondView = true
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color("newOrange"))
                    .frame(width: 300, height: 50)
                
                Text("Continue")
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(PlainButtonStyle()) // Ensures the button doesn't have a default style
        .frame(height: 100) // Keeps the overall height for layout consistency
    }

    
    private func heightWeightSelectionView(label: String, selection: Binding<Double>, showingSelection: Binding<Bool>) -> some View {
        VStack(spacing: 20) {
            HStack {
                Text(label)
                    .foregroundStyle(Color("newOrange"))

                Spacer()
                    .frame(width: 130)

                Button("\(selection.wrappedValue, specifier: "%.1f")") {
                    showingSelection.wrappedValue.toggle()
                }
                .frame(width: 85, height: 30)
                .foregroundStyle(Color.white)
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
            }
            .frame(width: 350)
            .padding(.vertical)
            .sheet(isPresented: showingSelection) {
                if label == "Height (ft)" {
                    HeightSelectionView(selectedHeight: selection)
                        .presentationDetents([.fraction(0.5)])
                } else {
                    WeightSelectionView(selectedWeight: selection)
                        .presentationDetents([.fraction(0.5)])
                }
            }
        }
    }

    private func saveUserData() {
        let height = String(format: "%.1f", selectedHeight)
        let weight = String(format: "%.0f", selectedWeight)
        
        UserDefaults.standard.set(viewModel.userGender, forKey: "userGender")
        UserDefaults.standard.set(height, forKey: "userHeightInCm")
        UserDefaults.standard.set(weight, forKey: "userWeight")
        
        print("Data we have Gender: \(viewModel.userGender), Height: \(height), Weight: \(weight)")
    }

    private func resetValues() {
        genderChosen = "Select Gender"
        selectedHeight = 5.0
        selectedWeight = 70.0
        isPresentingSecondView = false
    }
}

struct GenderButton: View {
    var gender: String
    @Binding var genderChosen: String
    @ObservedObject var viewModel: SignUPViewModel

    var body: some View {
        Button(action: {
            genderChosen = gender
            viewModel.userGender = gender
            UserDefaults.standard.set(viewModel.userGender, forKey: "userGender")
        }) {
            ZStack {
                if genderChosen == gender {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 140, height: 140)
                }
                Image(gender == "Male" ? "man_workingout" : "women_workingout")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    SignUpLandingScreen()
}
