//  Profile.swift
//  Physiotherapy
//
//  Created by Shagun on 28/05/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import WebKit

class ViewModel: ObservableObject {
    
    func logOut() throws {
        try Auth.auth().signOut()
    }
}

enum NavigationLinkDestination {
    case bodyMeasurements
    case formCheckTool
    case calorieTracker
    case connectToTrainer
    case privacyPolicy
    case resetPassword
}

struct WebView : UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct PrivacyPolicyWebPage : View {
    var body: some View {
        WebView(url: URL(string: "https://vigour-fit.com/privacy")!)
    }
}

struct Profile: View  {
    @ObservedObject var vm1:HomeVM=HomeVM()
    var vm = ViewModel()
    @ObservedObject var signUpViewModel = SignUPViewModel()
    //    @StateObject var user = UserViewModel()
    @State var showSignUp: Bool = false
    @State private var showLogoutAlert = false
    @State private var confirmLogout = false
    //-------------
    //MARK: for formCheckTool
    @State private var showingAlert = false
    @State private var navigationCount = UserDefaults.standard.integer(forKey: "NavigationCount")
    @State private var currentWeek = Calendar.current.component(.weekOfYear, from: Date())
    
    @Environment(\.dismiss) var dismiss
    
    @State var isBodyMeasurementPressed = false
    @State var isFormCheckToolPressed = false
    @State var isCalorieTrackerPressed = false
    @State var isConnectToTrainerPressed = false
    @State var isPrivacyPolicyPressed = false
    @State var isResetPasswordPressed = false
    @State private var showUserDetails = false
    
    @Binding var retrievedUserPhoto: UIImage?
    @Binding var userProfilePhotoPath: String
    @Binding var userName:String

    let imageList = ["square.and.pencil","square.and.pencil","shield","menubar.rectangle","lock","questionmark.circle","questionmark.circle","power"]
    let profileList = ["User Details","Body Measurements", "Form Check Tool", "Calorie Tracker", "Connect To Trainer", "Privacy Policy", "Reset Password", "Logout"]
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    
    var body: some View {
        NavigationView {
            GeometryReader{ geo in
                VStack{
                    List {
                        ForEach(profileList.indices, id: \.self) { index in
                            let profile = profileList[index]
                            let image = imageList[index]
                            
                            if profile == "User Details"{
                                NavigationLink(destination:
                                                UserDetailsView(newUsername: $userName, selectedImage: $retrievedUserPhoto)
                                ) {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(red: 0.18, green: 0.18, blue: 0.18))
                                            .frame(width: 350, height: 80)
                                            .padding(.leading,20)
                                        
                                        HStack(spacing: 15) {
                                            if !userProfilePhotoPath.isEmpty || retrievedUserPhoto != UIImage(named: "userImage")! {
                                                
                                                Image(uiImage: retrievedUserPhoto!)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 55,height: 55,alignment: .leading)
//                                                    .padding(.leading)
                                                
                                                
                                            } else {
                                                Circle()
                                                    .fill(Color(uiColor: UIColor(hex: "D9D9D9", alpha: 1.0)!))
                                                    .frame(width: 55, height: 55)
//                                                    .padding(.leading)
                                            }
                                            
                                            
                                            
                                            VStack(alignment: .leading, spacing: 3){
                                                Text(userName)
                                                    .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                                                    .font(.headline)
                                                    .multilineTextAlignment(.leading)
                                                Text("Personal Details")
                                                    .font(.custom("cabin", size: 14))
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundStyle(.white)
                                            }
                                            
                                            
                                            Spacer() // Add spacing to separate text and chevron
                                            Image(systemName: "chevron.right") // Add right chevron
                                                .foregroundColor(Color("profilecolor"))
                                        }
                                        .padding(.leading,35)
                                    }
                                }
                                .navigationBarHidden(true)
                            }else if profile == "Logout"{
                                Button(action: {
                                    confirmLogout = true
                                }, label: {
                                    HStack {
                                        Image(systemName: image)
                                            .foregroundColor(Color("profilecolor"))
                                        Text("Log Out")
                                            .foregroundColor(Color("profilecolor"))
                                        Spacer() // Add spacing to separate text and chevron
                                        Image(systemName: "chevron.right") // Add right chevron
                                            .foregroundColor(Color("profilecolor"))
                                    }
                                    .padding(.bottom)
                                })
                                .alert(isPresented: $confirmLogout) {
                                    Alert(
                                        title: Text("Confirm Logout"),
                                        message: Text("Are you sure you want to log out?"),
                                        primaryButton: .cancel(),
                                        secondaryButton: .destructive(Text("Logout")) {
                                            Task {
                                                do {
                                                    try vm.logOut()
                                                    UserDefaults.standard.set(0, forKey: "NavigationCount")
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        self.showSignUp = true
                                                    }
                                                } catch let error {
                                                    print("Error logging out: \(error.localizedDescription)")
                                                }
                                            }
                                        }
                                    )
                                }
                            }
                            else{
                                Button(action: {
                                    handleProfileAction(profile)
                                }) {
                                    HStack {
                                        Image(systemName: image)
                                            .foregroundColor(Color("profilecolor"))
                                        Text(profile)
                                            .foregroundColor(Color("profilecolor"))
                                        Spacer() // Add spacing to separate text and chevron
                                        Image(systemName: "chevron.right") // Add right chevron
                                            .foregroundColor(Color("profilecolor"))
                                    }
                                    .padding(.bottom)
                                }
                            }
                            
                            
                        }
                        .listRowBackground(Color.clear)
                    }
                    .padding(.top,-5)
                    
                    .scrollContentBackground(.hidden)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            
            .background{
                ZStack {
                    Color(red: 0.13, green: 0.13, blue: 0.13)
                        .ignoresSafeArea(.all)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        
        
        .accentColor(.primary)
        .fullScreenCover(isPresented: $isConnectToTrainerPressed) {
            ConnectToTrainer()
            
        }
        .fullScreenCover(isPresented: $isCalorieTrackerPressed) {
            Physiotherapy(selectedTab: 2)
            
        }.fullScreenCover(isPresented: $isPrivacyPolicyPressed) {
            VStack {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                        .foregroundColor(Color("newOrange"))
                        .padding(8)
                        .onTapGesture {
                            isPrivacyPolicyPressed = false
                        }
                    Spacer()
                }.padding(.leading)
                
                PrivacyPolicyWebPage()
            }
        }
        //===========================
        .fullScreenCover(isPresented: $isFormCheckToolPressed) {
            FormCheckToolView()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Alert"),
                  message: Text("You have reached your limit for this week."),
                  dismissButton: .default(Text("OK")))
        }

        .fullScreenCover(isPresented: $isBodyMeasurementPressed) {
            BodyMeasurementView()
            
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignInScreen(isVerifiedCheck: false)
        }
        .fullScreenCover(isPresented: $isResetPasswordPressed) {
            ResetPasswordView()
            
        }
    }
    private func handleProfileAction(_ profile: String) {
        switch profile {
        case "Body Measurements":
            isBodyMeasurementPressed = true
        case "Form Check Tool":
            //isFormCheckToolPressed = true
            checkNavigationLimit()
        case "Calorie Tracker":
            isCalorieTrackerPressed = true
        case "Connect To Trainer":
            isConnectToTrainerPressed = true
        case "Privacy Policy":
            isPrivacyPolicyPressed = true
        case "Reset Password":
            isResetPasswordPressed = true
        case "Logout":
            showLogoutAlert = true
        default:
            break
        }
    }

    //-------------
    func checkNavigationLimit() {
        let savedWeek = UserDefaults.standard.integer(forKey: "CurrentWeek")
        let currentWeek = Calendar.current.component(.weekOfYear, from: Date())
        if currentWeek != savedWeek {
            UserDefaults.standard.set(currentWeek, forKey: "CurrentWeek")
            UserDefaults.standard.set(0, forKey: "NavigationCount")
        }

        let navigationCount = UserDefaults.standard.integer(forKey: "NavigationCount")
        if navigationCount >= 3 {
            showingAlert = true
        } else {
            isFormCheckToolPressed = true
            UserDefaults.standard.set(navigationCount + 1, forKey: "NavigationCount")
            // Logging out
        }
        print("navigationCount---------", navigationCount)
        print("savedWeek---------", savedWeek)
        print("currentWeek---------", currentWeek)
        
    }
}
