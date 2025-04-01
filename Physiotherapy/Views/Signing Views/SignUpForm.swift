//
//  SignUpForm.swift
//  Physiotherapy
//
//  Created by Priya Dube on 28/06/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct SignUpForm: View {
    
    @State var homeVM = HomeVM()
    var padding: Double
    
    @State private var signUpName: String = ""
       @State private var signUpEmail: String = ""
       @State private var signUpPhoneNumber: String = ""
       @State private var signUpPassword: String = ""
       @State private var signUpReTypePassword: String = ""
       @State private var selectedDate = Date()
       @State private var isChecked = false
       @State private var isPresentingSecondView = false
       @State private var showingAlert = false
       @State private var alertTitle: String = ""
       @State private var alertMessage: String = ""
       @State private var referralCode: String = ""
       @State private var referralCodeList: [String] = []
       @State private var isRegisterDisabled: Bool = true
      @State var isVerifiedCheck: Bool = false
      @State private var selectedCountryCode: String = "+1"
      
      @StateObject private var viewModel = SignUPViewModel()
      var brownColor: Color = Color("brownColor")
      var orangeColor: Color = Color("orangeColor")
    var body: some View {
        
        NavigationView {
            GeometryReader { geo in
                
                VStack {
                    
                    Text("Register")
                        .bold()
                        .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                        .font(.custom("cabin", size: 40))
                        .padding(.top, padding)
                    
                    ScrollView {
                        TextField(text: self.$signUpName) {
                            Text("Name")
                                .foregroundStyle(Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)).bold()
                        }
                        .frame(width: 350, height: 50)
                        .padding(.leading, 21)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29))
                                .frame(width: 350, height: 50)
                        }
                        .padding(.top, 15)
                        .foregroundStyle(.white)
                        .autocapitalization(.none)
                        
                        // Email field with validation
                        TextField(text: self.$signUpEmail) {
                            Text("Email")
                                .foregroundStyle(Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)).bold()
                        }
                        .frame(width: 350, height: 50)
                        .padding(.leading, 21)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29))
                                .frame(width: 350, height: 50)
                        }
                        .padding(.top, 15)
                        .foregroundStyle(.white)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        
                        HStack(spacing: 10) {Picker(selection: $selectedCountryCode, label: Text("Country Code").foregroundColor(.white)) {
                                                        Text("+1").tag("+1")
                                                        Text("+91").tag("+91")
                                                        Text("+44").tag("+44")
                                                        Text("+61").tag("+61")
                                                        Text("+81").tag("+81")
                                                        Text("+49").tag("+49")
                                                        Text("+33").tag("+33")
                                                        Text("+39").tag("+39")
                                                        Text("+34").tag("+34")
                                                        Text("+86").tag("+86")
                                                        Text("+7").tag("+7")
                                                    }
                                                    .frame(width: 100, height: 50)
                                                    .foregroundColor(.white)
                                                    .accentColor(.white)
                                                    .background(Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29))
                                                    .cornerRadius(10)
                                                    
                                                    TextField("Contact Number", text: self.$signUpPhoneNumber)
                                                        .foregroundColor(.white)
                                                        .bold()
                                                        .keyboardType(.phonePad)
                                                        .frame(width: 240, height: 50)
                                                        .background {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29))
                                                        }
                                                }
                                                .padding(.top, 15)
                        // Date of birth field
                        HStack {
                            Text("Date of birth")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 10)
                                .foregroundStyle(Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!))
                                .padding(.leading, 21)
                            DatePicker(selection: $selectedDate, displayedComponents: .date, label: {})
                                .padding(.trailing, 28)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29))
                                .frame(width: 350, height: 50)
                        }
                        .padding(.top, 15)
                        .foregroundStyle(.white)
                        
                        // Referral code field
                        TextField(text: self.$referralCode) {
                            Text("Referral code")
                                .foregroundStyle(Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)).bold()
                        }
                        .frame(width: 350, height: 50)
                        .padding(.leading, 21)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29))
                                .frame(width: 350, height: 50)
                        }
                        .padding(.top, 15)
                        .foregroundStyle(.white)
                        .autocapitalization(.none)
                        
                        // Password field
                        SecureField(text: self.$signUpPassword) {
                            Text("Password")
                                .foregroundStyle(Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)).bold()
                        }
                        .frame(width: 350, height: 50)
                        .padding(.leading, 21)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29))
                                .frame(width: 350, height: 50)
                        }
                        .padding(.top, 15)
                        .foregroundStyle(.white)
                        .autocapitalization(.none)
                        
                        // Re-Enter Password field
                        SecureField(text: self.$signUpReTypePassword) {
                            Text("Confirm Password")
                                .foregroundStyle(Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)).bold()
                        }
                        .frame(width: 350, height: 50)
                        .padding(.leading, 21)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29))
                                .frame(width: 350, height: 50)
                        }
                        .padding(.top, 15)
                        .foregroundStyle(.white)
                        .autocapitalization(.none)
                        
                        HStack {
                            Spacer()
                            Circle()
                                .fill(Color(uiColor: UIColor(hex: self.isChecked ? "FF7D05" : "A0A0A0", alpha: self.isChecked ? 1.0 : 0.30)!))
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    self.isChecked.toggle()
                                }
                            HStack(spacing: 0) {
                                Text("I accept the ")
                                    .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                                Link("terms and conditions", destination: URL(string: "https://vigour-fit.com/terms")!)
                                    .underline()
                                    .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                            }
                            Spacer()
                        }
                        .padding(.top)
                        
                        VStack {
                            Button("Register") {
                                
                                viewModel.userName = signUpName
                                viewModel.userEmail = signUpEmail
                                viewModel.userPhoneNumber = signUpPhoneNumber
                                viewModel.userPassword = signUpPassword
                                viewModel.referralCode = referralCode
                                viewModel.userGender = UserDefaults.standard.string(forKey: "userGender") ?? "Male"
                                viewModel.userHeightInCm = UserDefaults.standard.string(forKey: "userHeightInCm") ?? "5"
                                viewModel.userWeight = UserDefaults.standard.string(forKey: "userWeight") ?? ""
                                
                                // Validations
                                if viewModel.userName.isEmpty {
                                    showingAlert = true
                                    alertTitle = "Invalid Name"
                                    alertMessage = "Please enter valid name"
                                } else if !isValidEmail(viewModel.userEmail) {
                                    showingAlert = true
                                    alertTitle = "Invalid Email"
                                    alertMessage = "Please enter a valid email address."
                                } else if !isNumeric(viewModel.userPhoneNumber) {
                                    showingAlert = true
                                    alertTitle = "Invalid Phone Number"
                                    alertMessage = "Phone Number should be numeric only."
                                } else if viewModel.userPhoneNumber.count < 10 {
                                    showingAlert = true
                                    alertTitle = "Invalid Phone Number"
                                    alertMessage = "Phone Number should have at least 10 characters."
                                } else if viewModel.userPassword.count < 8 {
                                    showingAlert = true
                                    alertTitle = "Invalid Password"
                                    alertMessage = "Password should be more than 8 characters."
                                } else if viewModel.userPassword != signUpReTypePassword {
                                    showingAlert = true
                                    alertTitle = "Re-Type the Password fields"
                                    alertMessage = "Password and Re-Type Password don't match."
                                } else if viewModel.referralCode.isEmpty {
                                    showingAlert = true
                                    alertTitle = "Referral code missing"
                                    alertMessage = "Referral to get connected to the trainer is missing."
                                } else if !referralCodeList.contains(viewModel.referralCode) {
                                    showingAlert = true
                                    alertTitle = "Referral code invalid"
                                    alertMessage = "Referral to get connected to the trainer is invalid."
                                } else if !isChecked {
                                    showingAlert = true
                                    alertTitle = "Accept T&C"
                                    alertMessage = "In order to sign up, you need to accept the terms and conditions."
                                } else {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd/MMMM/YYYY/EEEE"
                                    let myDate = formatter.string(from: selectedDate)
                                    
                                    viewModel.userDOB = myDate
                                    print("On Submit button of SignUp - Data going to save is : Name \(viewModel.userName), Email : \(viewModel.userEmail), PhoneNumber: \(viewModel.userPhoneNumber), Password: \(viewModel.userPassword), date; \(viewModel.userDOB), Gender: \(viewModel.userGender), Height: \(viewModel.userHeightInCm), weight: \(viewModel.userWeight) ")
                                    
                                    viewModel.SigningUp { success in
                                        if success {
                                            isPresentingSecondView = true
                                        } else {
                                            showingAlert = true
                                            alertTitle = "Sign Up Failed"
                                            alertMessage = "There was an error signing up. Please try again."
                                        }
                                    }
                                }
                            }
                            .frame(width: 180, height: 50)
                            .foregroundStyle(.white)
                            .disabled(isRegisterDisabled)
                            .fullScreenCover(isPresented: $isPresentingSecondView) {
                                if getIsUserVerified() {
                                    Physiotherapy(selectedTab: 0)
                                } else {
                                    ConnectToTrainer(isFromSignin: true)
                                }
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                            }
                            .padding(.top)
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text(alertTitle),
                                  message: Text(alertMessage),
                                  dismissButton: .default(Text("Okay")))
                        }
                        
                        Spacer()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .onAppear {
                    getreferralCodes()
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
                }
                .aspectRatio(contentMode: .fit)
            }
        }
    }
    
    private func getreferralCodes() {
        let trainer = Firestore.firestore()
        trainer.collection("physiotherapist").getDocuments { snapshot, _ in
            if let snapshot {
                for doc in snapshot.documents {
                    _ = doc.data()
                    referralCodeList.append(doc["referralCode"] as? String ?? "No code")
                }
                isRegisterDisabled = false
            }
        }
    }
    
    func getIsUserVerified() -> Bool {
        let userid = Auth.auth().currentUser?.uid ?? ""
        let db = Firestore.firestore()
        db.collection("Users").whereField("userId", isEqualTo: userid).getDocuments { snapshot, _ in
            if let snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    isVerifiedCheck = data["verified"] as? Bool ?? false
                }
            }
        }
        return isVerifiedCheck
    }
    
    // Email validation function
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // Numeric validation function
    private func isNumeric(_ string: String) -> Bool {
        return Double(string) != nil
    }
}

struct SignUpForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpForm(padding: 0)
        }
    }
}

