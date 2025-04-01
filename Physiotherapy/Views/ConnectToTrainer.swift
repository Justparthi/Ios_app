//
//  ConnectToTrainer.swift
//  Physiotherapy
//
//  Created by george kaimoottil on 05/12/23.
//
import SwiftUI
import Firebase


struct ConnectToTrainer: View {
    @State var checkRequestSent : Bool = false
    @State private var code: [String] = Array(repeating: "", count: 6)
    @State private var isCodeValid = false
    @State private var showFeaturesView = false
    @State private var isProfileViewPresented = false
    @State private var referralCodeList: [String] = []
    var orangeColor: Color = Color("orangeColor")
    var isFromSignin: Bool = false
    @State private var showingAlert = false
    @State private var loggingOut = false
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: "power")
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                            .offset(x:-180)
                            .onTapGesture {
                                do {
                                    try Auth.auth().signOut()
                                    loggingOut = true
                                } catch {
                                    
                                }
                            }.padding()
                        
                    }
                    
                    Text("Requesting the trainer....")
                        .font(.custom("cabin", size: 30))
                        .foregroundColor(Color("newOrange"))
                    
                    .padding()
                    
                    
                    Spacer()
                    
                }.frame(width: geo.size.width, height: geo.size.height)
                .onAppear {
                    checkReferralRequest()
                }
                .fullScreenCover(isPresented: $loggingOut) {
                    OnboardingS1()
                }
                .fullScreenCover(isPresented: $isProfileViewPresented) {
                    Physiotherapy(selectedTab: 4)
                }
                .sheet(isPresented: $showFeaturesView) {
                    FeaturesView(isPresented: $showFeaturesView, isVerified: false)
                        .presentationDetents([.medium,.large])
                        .presentationDetents([.fraction(0.35),.large])
                }.background {
                    Color(red: 0.13, green: 0.13, blue: 0.13)
                        .ignoresSafeArea(edges: .all)
                }
                
            }.aspectRatio(contentMode: .fill)
        }
        
    }
    
    private func handleCodeChange(_ index: Int) {
        // Ensure only one digit is allowed in each box
        let limitedCode = code[index].prefix(1)
        code[index] = String(limitedCode)
        
        // Move to the next box
        if index < 5 && !limitedCode.isEmpty {
            DispatchQueue.main.async {
                withAnimation {
                    // Use the focus property to move to the next TextField
                    code.indices.forEach { currentIndex in
                        if currentIndex == index + 1 {
                            code[currentIndex] = ""
                            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
            }
        }
    }
    
    private func addreferralCode(completion: @escaping (Bool) -> Void) {
        let referralCode = code.joined()
        let userId = Auth.auth().currentUser?.uid
        let ref = Firestore.firestore()
        let userRef = ref.collection("Users").document(userId!)
        
        userRef.updateData(["referralCode": referralCode]) { error in
            if let error = error {
                print("Error updating code : \(error.localizedDescription)")
                completion(false)
            } else {
                print("Code has been updated")
                completion(true)
            }}
        
    }
    
    private func getreferralCodes(){
        let trainer = Firestore.firestore()
        trainer.collection("physiotherapist").getDocuments(){ snapshot, _ in
            if let snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    referralCodeList.append(doc["referralCode"] as? String ?? "No code")
                }
                print(referralCodeList)
            }}
    }
    
    private func checkReferralRequest() {
        var r = ""
        let userid = Auth.auth().currentUser?.uid ?? ""
        let db = Firestore.firestore()
        db.collection("Users").whereField("userId", isEqualTo: userid).getDocuments() { snapshot, _ in
            if let snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    r = data["referralCode"] as? String ?? ""
                    print(r)
                    checkRequestSent = r.isEmpty
                    print(checkRequestSent)
                    showFeaturesView = !checkRequestSent
                    print(showFeaturesView)
                }
            }
        }
    }
    
    private func validateCode() {
        let isFilled = code.allSatisfy { $0.count == 1 && !$0.isEmpty }
        let enterdCode = code.joined()
        if isFilled {
            isCodeValid = true
            
            if referralCodeList.contains(enterdCode)
            {
                showFeaturesView = true
                addreferralCode { success in
                    if success {
                        print("Trainer code has been verified ")
                    }
                }
            } else {
                showingAlert = true
                print("Enter the correct trainer code")
            }
            
        } else {
            // Handle invalid code, show an alert or provide feedback to the user
            print("Invalid code. Please enter a 6-digit code.")
        }
    }
}

struct FeaturesView: View {
    @Binding var isPresented: Bool
    var __verified: Bool = false
    @State var isVerified: Bool
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(Color("newOrange"))
                            .padding(8)
                    }
                    Spacer()
                }
                .padding()
                Text("Request Sent!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 2, x: 1, y: 1)
                
                Text("Waiting For Approval")
                    .foregroundColor(.white)
                //                Divider()
                //                    .background(Color.black)
                //                    .frame(height: 40)
                //                HStack {
                //                    Image(systemName: "person.circle.fill")
                //                        .font(.largeTitle)
                //                        .foregroundColor(.gray)
                //                        .scaledToFill()
                //                    //                        .frame(width: 50, height: 50) // Increase the size of the image here
                //                        .clipShape(Circle())
                //                    VStack{
                //                        Text("Suresh Upadhay")
                //                            .foregroundColor(Color.primary)
                //                            .bold()
                //                        Text("CODE:SUPA25")
                //                            .font(.subheadline)
                //                            .foregroundColor(Color.black)
                //
                //                    }
                //                    .padding()
                //
                //                }
                //                .padding()
                //
                //                HStack{
                //                    Image(systemName: "mappin")
                //                        .font(.largeTitle)
                //                        .foregroundColor(.gray)
                //                        .scaledToFill()
                //                    //                        .frame(width: 50, height: 50) // Increase the size of the image here
                //                        .clipShape(Circle())
                //
                //                    Text("1701 Fleming Street,Hayneville")
                //                        .foregroundColor(Color.primary)
                //                        .bold()
                //                        .underline()
                //                }
                //                HStack {
                //                    NavigationLink(destination: Text("Call Feature")) {
                //                        FeatureRow(iconName: "phone.fill", featureName: "Call", isPresented: $isPresented)
                //                    }
                //
                //                    NavigationLink(destination: Text("Reviews Feature")) {
                //                        FeatureRow(iconName: "star.fill", featureName: "Reviews", isPresented: $isPresented)
                //                    }
                //
                //                    NavigationLink(destination: Text("Directions Feature")) {
                //                        FeatureRow(iconName: "location.fill", featureName: "Directions", isPresented: $isPresented)
                //                    }
                //
                //                    NavigationLink(destination: Text("Read More Feature")) {
                //                        FeatureRow(iconName: "text.book.closed.fill", featureName: "Read More", isPresented: $isPresented)
                //                    }
                //
                //                    //                    Spacer()
                //                }
                //                .padding()
                //                //                .navigationTitle("Features")
                //
                //                Button(action: {
                //
                //                }, label: {
                //                    Text("Next")
                //                        .frame(width: 100,height: 100)
                //                        .font(.title)
                //                        .foregroundColor(.primary)
                //                    //                        .background(.white)
                //                })
            }
            
            .fullScreenCover(isPresented: $isVerified) {
                Physiotherapy(selectedTab: 0)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    getIsUserVerified()
                }
                
            }
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
    
    func getIsUserVerified() {
        let userid = Auth.auth().currentUser?.uid ?? ""
        let db = Firestore.firestore()
        db.collection("Users").whereField("userId", isEqualTo: userid).getDocuments() { snapshot, _ in
            if let snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    isVerified = data["verified"] as? Bool ?? false
                }
            }
        }
    }
}


struct FeatureRow: View {
    var iconName: String
    var featureName: String
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(.black)
            
            Text(featureName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        //        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
        //        .padding(.bottom, 8)
    }
}
struct CodeBox: View {
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
        //            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray)
                .frame(width: 40,height: 40)
            )
            .frame(width: 40, height: 40)
            .multilineTextAlignment(.center)
        
    }
}

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

#Preview {
    ConnectToTrainer()
}
