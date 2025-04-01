//
//  DashBoard.swift
//  Physiotherapy
//
//  Created by Shagun on 13/05/23.
//


import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct Physiotherapy: View {
    
    @ObservedObject var homeVM: HomeVM = HomeVM()
    @State var selectedTab: Int
    @State var userName = "No Name"
    @State var retrievedUserPhoto: UIImage? = UIImage(named: "userImage")!
    @State var userProfilePhotoPath: String = ""
    @State var forlandingbool = true

    var lightPurple = Color(red: 0.4, green: 0.4, blue: 0.4)

    var body: some View {
        NavigationView {
            if forlandingbool {
                ZStack {
                    TempView()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.forlandingbool = false
                    }
                }
            } else {
                // Native TabView implementation
                TabView(selection: $selectedTab) {
                    // Home Tab
                    Home(userName: $userName, retrievedUserPhoto: $retrievedUserPhoto, userProfilePhotoPath: $userProfilePhotoPath)
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .tag(0)
                    
                    // Exercise Tab
                    ExerciseTab(userName: $userName)
                        .tabItem {
                            Image(systemName: "figure.run")
                            Text("Exercise")
                        }
                        .tag(1)
                    
                    // Nutrition Tab
                    Nutrition()
                        .tabItem {
                            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                            Text("Diet")
                        }
                        .tag(2)
                    
                    // Message Tab
                    MessageView()
                        .tabItem {
                            Image(systemName: "text.bubble.fill")
                            Text("Chat")
                        }
                        .tag(3)
                    
                    // Profile Tab
                    Profile(retrievedUserPhoto: $retrievedUserPhoto, userProfilePhotoPath: $userProfilePhotoPath, userName: $userName)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        .tag(4)
                }
                .accentColor(Color("newOrange"))  // Change the accent color of selected tab
                .background(.thinMaterial)  // Make background slightly transparent
                .onAppear {
                    // Fetch initial data on appearance
                    getProfilePhoto()
                    getUserName()
                    
                    // Customize tab bar appearance for transparency
                    customizeTabBarAppearance()
                }
            }
        }
    }

    // MARK: - Helper Functions
    func getUserName() {
        let userid = Auth.auth().currentUser?.uid ?? ""
        Firestore.firestore().collection("Users")
            .whereField("userId", isEqualTo: userid)
            .getDocuments { snapshot, _ in
                if let snapshot = snapshot {
                    for doc in snapshot.documents {
                        let data = doc.data()
                        self.userName = data["userName"] as? String ?? ""
                    }
                }
            }
    }

    func getProfilePhoto() {
        let userid = Auth.auth().currentUser?.uid ?? ""
        Firestore.firestore().collection("Users")
            .whereField("userId", isEqualTo: userid)
            .getDocuments { snapshot, _ in
                if let snapshot = snapshot {
                    for doc in snapshot.documents {
                        let data = doc.data()
                        self.userProfilePhotoPath = data["userProfilePhoto"] as? String ?? ""
                    }
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child("\(self.userProfilePhotoPath)")
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if data != nil && error == nil {
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    self.retrievedUserPhoto = image
                                }
                            }
                        }
                    }
                }
            }
    }

    // Function to customize Tab Bar appearance with transparency
    func customizeTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        
        // Use a blur effect for the background
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)  // You can use .light, .dark, or .systemMaterial styles
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UITabBar.appearance().frame.height)
        
        // Create a background image using the blur view
        let renderer = UIGraphicsImageRenderer(size: blurView.bounds.size)
        let image = renderer.image { _ in
            blurView.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        // Set the background image of the tab bar
        tabBarAppearance.backgroundImage = image
        tabBarAppearance.shadowImage = UIImage() // Remove default shadow
        
        // Apply the blur appearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

struct TempView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
//                Image("AppImage")
//                    .resizable()
//                    .frame(width: 100, height: 100)
            }
            .frame(width: geo.size.width, height: geo.size.height)
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
    }
}
