//
//  FireView_Updated.swift
//  Fire
//
//  Created by Himanshu Vinchurkar on 13/12/23.
//

import SwiftUI
import FirebaseFirestore

struct FireView_Updated: View {
    @State private var enteredLetters: [String] = Array(repeating: "", count: 6)
    private let db = Firestore.firestore()

    var body: some View {
        ZStack() {
            ZStack() {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 340, height: 506)
                    .background(Color(red: 1, green: 0.48, blue: 0))
                    .cornerRadius(20)
                    .offset(x: 0, y: 0)
                ZStack() {
                    ZStack() {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 30, height: 30)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.48, blue: 0), Color(red: 1, green: 0.48, blue: 0).opacity(0)]), startPoint: .top, endPoint: .bottom)
                            )
                            .offset(x: -27.50, y: -16.82)
                            .rotationEffect(.degrees(-45))
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 30, height: 30)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.48, blue: 0), Color(red: 1, green: 0.48, blue: 0).opacity(0)]), startPoint: .top, endPoint: .bottom)
                            )
                            .offset(x: -48.71, y: -16.68)
                            .rotationEffect(.degrees(-45))
                        
                    }
                    .frame(width: 42.57, height: 63.64)
                    .offset(x: -27.08, y: 10.82)
                    .rotationEffect(.degrees(-90))
                }
                .frame(width: 80, height: 80)
                .offset(x: 80, y: -155)
                .rotationEffect(.degrees(-90))
            }
            .frame(width: 340, height: 506)
            .offset(x: 0.50, y: 0)
            
            Image("Icon")
                .resizable()
                .frame(width: 70, height: 70)
                .offset(x: 0, y: -160)
           
            Text("Enter Therapist Code")
                .font(.system(size: 24).weight(.bold))
                .foregroundColor(Color(red: 0.17, green: 0.09, blue: 0.34))
                .offset(x: 1, y: -69)
            
            ZStack() {
                inputBox(text: $enteredLetters[0], offset: -115)
                            inputBox(text: $enteredLetters[1], offset: -69)
                            inputBox(text: $enteredLetters[2], offset: -23)
                            inputBox(text: $enteredLetters[3], offset: 23)
                            inputBox(text: $enteredLetters[4], offset: 69)
                            inputBox(text: $enteredLetters[5], offset: 115)
            }
            .offset(x: 2.50, y: -9)
            submitButton()
            cancelButton()
        }
        .frame(width: 395, height: 812)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.40, blue: 0), Color(red: 0.15, green: 0.02, blue: 0.02)]), startPoint: .top, endPoint: .bottom)
        )
    }
    
    private func finalLetters() -> String {
           return enteredLetters.joined()
       }
    
    private func fireUpdate()  {
        //Firebase func to update referral code
        let physiotherapist = db.collection("Users").document("BPC2PujufPpEef8QpDFW")

        physiotherapist.updateData([
          "referralCode": finalLetters()
        ]) { err in
          if let err = err {
            print("Error updating document: \(err)")
          } else {
            print("Document successfully updated")
          }
        }
    }

    private func inputBox(text: Binding<String>, offset: CGFloat) -> some View {
        TextField("", text: text)
            .keyboardType(.alphabet)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .frame(width: 40, height: 40)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.15, green: 0.02, blue: 0.2), Color(red: 0.15, green: 0.02, blue: 0.02).opacity(0)]), startPoint: .top, endPoint: .bottom)
            )
            .overlay(
                Rectangle()
                    .inset(by: 0.50)
                    .stroke(Color(red: 0.15, green: 0.02, blue: 0.02), lineWidth: 0.50)
            )
            .offset(x: offset, y: 0)
            .frame(width: 40, height: 40)
            .onChange(of: text.wrappedValue) {
                if text.wrappedValue.count > 1 {
                    text.wrappedValue = String(text.wrappedValue.prefix(1))
                }
            }
        
    }




    private func submitButton() -> some View {
        Button(action: {
            fireUpdate()
            print("Updated sucessfully")
        }) {
            ZStack() {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 132, height: 50)
                    .background(Color(red: 0.15, green: 0.02, blue: 0.02))
                    .cornerRadius(15)
                    .offset(x: 0, y: 0)
                    .shadow(
                        color: Color(red: 0.15, green: 0.02, blue: 0.02, opacity: 1), radius: 4, y: 4
                    )
                
                Text("Submit")
                    .font(Font.custom("Roboto", size: 16).weight(.medium))
                    .foregroundColor(.white)
                    .offset(x: 0.50, y: 0.50)
            }}
            .frame(width: 132, height: 50)
            .offset(x: 71.50, y: 164)
        }

    private func cancelButton() -> some View {
        Button(action: {
            //Your code?
        }) {
            ZStack() {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 132, height: 50)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .inset(by: 1)
                            .stroke(Color(red: 0.15, green: 0.02, blue: 0.02), lineWidth: 1.5)
                    )
                    .offset(x: 0, y: 0)
                
                Text("Cancel")
                    .font(Font.custom("Roboto", size: 16).weight(.medium))
                    .foregroundColor(.white)
                    .offset(x: 0.50, y: 0.50)
            }}
        .frame(width: 132, height: 50)
        .offset(x: -66.50, y: 164)
    }
}



#Preview {
    FireView_Updated()
}

