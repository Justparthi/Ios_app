//
//  ContentView.swift
//  Physiotherapy
//
//  Created by Shagun on 12/05/23.
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


// MARK: SignInViewModel
//Firebase Sign In with Email/ Password
//@MainActor
//final class SignUPViewModel: ObservableObject{
//
//
//    let db = Firestore.firestore()
//
//
//     @Published var userData = [UserSignUpInfo]()
//     @Published var email = "testing1@mail.com"
//     @Published var passowrd = "123456"
//     @Published var userID: String = ""
//      //var userEmail: String = "testing1@mail.com"
//     @Published var userPassword: String = "123456"
//     @Published var userGender: String = "Female"
//     @Published var userHeightInCm: String = "165"
//     @Published var userWeight: String = "99"
//     @Published var userDOB: String = "24-Jun-2000"
//     @Published var userName: String = "New User"
//     @Published var userPhoneNumber: String = "876543219"
//
//
//
//    func SignUp(){
//
//        guard !email.isEmpty, !passowrd.isEmpty else{
//            print("No email or password found")
//            return
//        }
//
//        Task{
//            do{
//                let returnedUserData = try await AuthenticationManager.shared.createEmailPassword(
//                    email: email, password: passowrd)
//
//                print("Success")
//
//            }catch{
//                print("Error : \(error)")
//            }
//        }
//
//    }
//
//    // Save the user information
//    func saveUserInformation(id: String, userId: String, userEmail: String, userPassword: String, userGender: String, userHeightInCm: String, userWeight: String, userName: String, userPhoneNumber: String){
//
//        let checking = db.collection("UserLogInInfo")
//
//        print(checking)
//        //Get reference to the database
//        db.collection("UserLogInInfo").addDocument(data: ["userId": userId, "userEmail": userEmail, "userPassword": userPassword, "userGender": userGender, "userHeightInCm": userHeightInCm, "userWeight": userWeight, "userName": userName, "userPhoneNumber": userPhoneNumber]) { error in
//            //Checking for errors
//            if error == nil{
//                //No error
//
//                //Calling get data to retrieve latest data
//            }else{
//                //handle error
//            }
//        }
//    }
//
//
//    func updateUserData(userId: String, userEmail: String, userPassword: String, userGender: String, userHeightInCm: String, userWeight: String, userName: String, userPhoneNumber: String){
//
////        db.collection("UserLogInInfo").document().setData(
////            [
////            "userEmail": "email@email.com",
////            "userHeightInCm": "678"
////        ])
//
//
//
//
//        let ref = db.collection("UserLogInInfo").document()
////        let ref = firestore.collection(myCollection).document()
////        // ref is a DocumentReference
//        let id = ref.documentID
////        // id contains the random ID
//
//        print("We have id :\(id)")
//
//        db.collection("UserLogInInfo").document().setData(
//            ["userEmail": userEmail,
//             "userPassword": userPassword,
//             "userGender": userGender,
//             "userHeightInCm": userHeightInCm,
//             "userWeight": userWeight,
//             "userName": userName,
//             "userPhoneNumber": userPhoneNumber])
//            { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
//    }
//
//
//
//}


// MARK: SignInView
struct SignInView: View {
    @State private var isLoggedIn = false
    @State private var showForgotPasswordView = false
    @State private var showingAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
//    @State private var username: String = ""
//    @State private var password: String = ""
    @State private var isPresentingSecondView = false
    // Firebase Authentication : Email/Password
    @StateObject private var viewModel = SignUPViewModel()
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    Spacer()
                    VStack{
                        Text("Sign In")
                            .bold()
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                            .font(.system(size: 35))
                        
                        /*
                         Email field.
                         */
                        
                        TextField(text: $viewModel.userEmail) {
                            Text("Email")
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
                            }.padding(.top, 15)
                            .foregroundStyle(.white)
                        
                        /*
                         Password field.
                         */
                        
                        SecureField(text: $viewModel.userPassword) {
                            Text("Password")
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
                            }.padding(.top, 15)
                            .foregroundStyle(.white)
                        
                        HStack {
                            Spacer()
                            Button {
                                showForgotPasswordView = true
                            } label: {
                                Text("Forgot password")
                                    .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                                    .padding(.top, 15)
                            }
                        }.padding(.trailing)
                        
                        
                        Button("Log In") { logIn() }
                            .bold()
                            .font(.system(size: 24))
                            .frame(width: 180, height: 60)
                            .foregroundStyle(.white)
                            .fullScreenCover(isPresented: $isLoggedIn) {
                                                Physiotherapy(selectedTab: 0)
                                            }
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                            }.padding(.top)
                        
                        Text("Dont have an account?")
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                            .padding(.top, 15)
                        NavigationLink(destination: SignUpView()) {
                            Text("Register Here")
                                .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                                .underline()
                            
                        }
                        
                    }
                    .padding()
                    if showForgotPasswordView {
                        brownColor.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showForgotPasswordView = false
                                }
                            }
                        
                        VStack {
                            Spacer()
                            ForgotPasswordView()
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut)
                                .frame(width: UIScreen.main.bounds.width, height: 270)
                                .background(Color.orange)
                                .cornerRadius(16)
                        }
                        .padding()
                    }
                    
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
}

// MARK: - CustomTextField
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(Color.black)
            .foregroundColor(Color.white)
            .cornerRadius(8)
    }
}

// MARK: SignUpView
struct SignUpView: View{
    @State private var value = 0.5
    @State private var value2 = 0.5
    @State private var isPresentingSecondView = false
    @State private var isMen = false
    @State private var isWomen = false
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    @StateObject private var viewModel = SignUPViewModel()
    
    var body: some View {
        VStack{
            Text("Let us know who you are?")
                .font(.title)
                .padding(.bottom,40)
                .bold()
                .foregroundStyle(Color("newOrange"))
            
            Text("To give you a customized experience we need to know your details!").padding(.leading,10).foregroundColor(Color.white)
                .padding(.horizontal, 15)
                .multilineTextAlignment(.center)
                .padding(.bottom,20)
            
            Text("Choose one:").frame(maxWidth: .infinity,alignment: .leading).padding(.leading,30).foregroundColor(Color("newOrange"))
            
            
            HStack(spacing: 20){
                
                Button(action: {
                    viewModel.userGender = "Male"
                    UserDefaults.standard.set(viewModel.userGender, forKey: "userGender")}) {
                        Image("men")
                    }
                
                Button(action: {
                    viewModel.userGender = "Female"
                    UserDefaults.standard.set(viewModel.userGender, forKey: "userGender")}) {
                        Image("women")
                    }
            }
            .padding(.top,20)
            
    //MARK: Height Slider
            VStack(spacing: 20) {
                HStack {
                    Text("Height(cm)")
                        .foregroundStyle(Color("newOrange"))
                    Spacer()
                        .frame(width: 160)
                    Text("\(value, specifier: "%.2f")")
                        .frame(width: 85, height: 30)
                        .foregroundStyle(Color.white)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                }
                .frame(width: 350)
                .foregroundColor(brownColor)
                
                Slider(value: $value, in: 10...150, step: 0.5)
                        .accentColor(Color("newOrange"))
                        .padding(.horizontal)
        }
                  .padding(.vertical)

               
    //MARK: Weight Slider
            VStack {
                HStack(spacing: 20) {
                    Text("Weight(kg)")
                        .foregroundStyle(Color("newOrange"))
                    Spacer()
                        .frame(width: 120)
                    Text("\(value2, specifier: "%.2f")")
                        .frame(width: 85, height: 30)
                        .foregroundStyle(Color.white)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                }
                .frame(width: 350)
                
                Slider(value: $value2, in: 0...150, step: 0.5)
                    .accentColor(Color("newOrange"))
                    .padding(.horizontal)
                    
            }
                    
                ZStack{
                    RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50) .foregroundStyle(Color("newOrange"))
                    
                        
                        Button("Continue") {
                                               
                        let height : String = String (format: "%f", value)
                        let weight : String = String (format: "%f", value2)

                        UserDefaults.standard.set(viewModel.userGender, forKey: "userGender")
                        UserDefaults.standard.set(height, forKey: "userHeightInCm")
                        UserDefaults.standard.set(weight, forKey: "userWeight")

                        print("Data we have  Gender : \(viewModel.userGender), Height : \(height), Weight: \(weight)")
                        
                        isPresentingSecondView = true
                        
                    }.foregroundColor(.white)
                    .fullScreenCover(isPresented: $isPresentingSecondView) {
                        SignUpForm(padding: 0.0)
                        }
                }.frame(height: 100)
                
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
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
    }
}

// MARK: SignUpView2
struct SignUpView2: View {
    @State private var Name: String = ""
    @State private var email: String = ""
    @State private var PhoneNumber: String = ""
    @State private var password1: String = ""
    @State private var password2: String = ""
    @State private var selectedDate = Date()
    @State private var isChecked = false
    @State private var isPresentingSecondView = false
    @State private var showingAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var referralCode: String = ""
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    @StateObject var viewModel = SignUPViewModel()
    
    
    var body: some View {
        
        
        GeometryReader { geo in
            VStack {
                
                Text("Register")
                    .bold()
                    .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                    .font(.custom("cabin", size: 35))
                    .padding(.top, 40)
                
                /*
                 Name field.
                 */
                
                
                TextField(text: self.$Name) {
                    Text("Name")
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
                    }.padding(.top, 15)
                    .foregroundStyle(.white)
                
                /*
                 Email field.
                 */
                
                TextField(text: self.$email) {
                    Text("Email")
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
                    }.padding(.top, 15)
                    .foregroundStyle(.white)
                
                /*
                 Contact number field
                 */
                
                TextField(text: self.$PhoneNumber) {
                    Text("Contact Number")
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
                    }.padding(.top, 15)
                    .foregroundStyle(.white)
                
                /*
                 DOB field
                 */
                
                
                //                TextField("", text: self.$selectedDate)
                //                    .frame(width: 350, height: 50)
                //                    .disabled(true)
                //                    .padding(.leading)
                //                    .foregroundStyle(.white)
                //                    .background {
                //                        RoundedRectangle(cornerRadius: 40)
                //                            .fill(
                //                                Color(red: 0.63, green: 0.63, blue: 0.63).opacity(0.29)
                //                            ).frame(width: 350, height: 50)
                //                            .overlay {
                //                                if(self.dobStr.isEmpty) {
                //                                    HStack {
                //                                        Text("Date of birth")
                //                                            .foregroundStyle(
                //                                                Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!)
                //                                            ).bold()
                //                                        Spacer()
                //
                //                                        Image(.DOB)
                //                                            .padding(.trailing, 24)
                //                                            .id(self.calendarID)
                //                                            .overlay {
                //                                                DatePicker("", selection: self.$dob)
                //                                                    .blendMode(.destinationOver)
                //                                                    .onChange(of: self.dob) { () in
                //                                                        let dateFormatter = DateFormatter()
                //                                                        dateFormatter.dateFormat = "dd/MM/YYYY"
                //                                                        self.calendarID += 1
                //                                                        self.dobStr = dateFormatter.string(from: self.dob)
                //                                                    }
                //                                            }
                //
                //
                //                                    }.padding(.leading)
                //                                }
                //                            }
                //                    }.padding(.top, 15)
                HStack{
                            Text("Date of birth")
                                .frame(maxWidth: .infinity,alignment:.leading)
                                .padding(.leading,10)
                                .foregroundStyle(Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!))
                
                            DatePicker(
                                selection: $selectedDate,
                                displayedComponents: .date,
                                label: {}
                            )
                            .foregroundStyle(Color(uiColor: UIColor(hex: "939393", alpha: 1.0)!))
                
                        }
                /*
                 Referral code field
                 */
                
                TextField(text: self.$referralCode) {
                    Text("Referral code")
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
                    }.padding(.top, 15)
                    .foregroundStyle(.white)
                
                /*
                 Password field
                 */
                
                SecureField(text: self.$password1) {
                    Text("Password")
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
                    }.padding(.top, 15)
                    .foregroundStyle(.white)
                
                /*
                 Re-Enter Password field
                 */
                
                SecureField(text: self.$password2) {
                    Text("Confirm Password")
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
                    }.padding(.top, 15)
                    .foregroundStyle(.white)
                
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color(uiColor: UIColor(hex: self.isChecked ? "FF7D05" : "A0A0A0",
                                                     alpha: self.isChecked ? 1.0 : 0.30)!))
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            self.isChecked.toggle()
                        }
                    HStack(spacing: 0) {
                        Text("I accept the ")
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FFBD82", alpha: 1.0)!))
                        Text("terms and conditions")
                            .underline()
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                    }
                    
                    Spacer()
                }
                .padding(.top)
                
                VStack {
                    Button("Register") {
                        //                    Assiging pages value
                        viewModel.userEmail = email
                        viewModel.userName = Name
                        viewModel.userPassword = password2
                        viewModel.userPhoneNumber = PhoneNumber
                        viewModel.referralCode = referralCode
                        
                        // Assigning User defaults value from landing page
                        viewModel.userGender = UserDefaults.standard.string(forKey: "userGender") ?? ""
                        viewModel.userHeightInCm = UserDefaults.standard.string(forKey: "userHeightInCm") ?? ""
                        viewModel.userWeight = UserDefaults.standard.string(forKey: "userWeight") ?? ""
                        
                        // Create Date Formatter
                        let formatter = DateFormatter()
                        // Convert Date to String
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
                    .bold()
                    .font(.system(size: 24))
                    .frame(width: 180, height: 60)
                    .foregroundStyle(.white)
                    .fullScreenCover(isPresented: $isPresentingSecondView){
                        Physiotherapy(selectedTab: 0)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                }.padding(.top)
                }
                .alert(isPresented: $showingAlert){
                    Alert(title: Text(alertTitle),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("Okay")))
                }
                
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
    


// MARK: Sign
struct Sign: View {
    var body: some View {
        NavigationView {
            SignInView()
            SignUpView2()
        }
    }
}


// MARK: ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Sign()
        SignUpView()
        SignUpForm(padding: 0.0)
    }
}

extension SignInView {
    
    func logIn() {
        guard !viewModel.userEmail.isEmpty,
              !viewModel.userPassword.isEmpty else {
            showingAlert = true
            alertTitle = "Invalid Email"
            alertMessage = "Please enter valid Email"
            return }
        
        Task {
            do {
                try await viewModel.signIn(userEmail: viewModel.userEmail, userPassword: viewModel.userPassword)
                isLoggedIn = true
                
            }catch let error {
                showingAlert = true
                print("Error signing in: \(error.localizedDescription)")
            }
        }
    }
}
