//
//  PhysiotherapyApp.swift
//  Physiotherapy
//
//  Created by Shagun on 09/05/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase
import FirebaseDatabaseSwift


@main
struct PhysiotherapyApp: App {
    @StateObject var recorder = Recorder()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var homeVM = HomeVM()

    @State var uiimage: UIImage?

    var body: some Scene {
        WindowGroup {
//            Physiotherapy(selectedTab: 0)
            NavigationStack {
                if Auth.auth().currentUser == nil {
                    OnboardingS1()
                } else {
                    ConnectToTrainer(isFromSignin: true)
//                    Physiotherapy(selectedTab: 0)
//                        .environmentObject(homeVM)
                }

            }.environmentObject(SignUPViewModel())
            //creating an environment Object for SignUpViewModel gives access to Model without creating multiple objects for every screen to access userID. It is a commom object of class for userID
        }
    }
    
    func getData() {
        
            Utilities.shared.getExercise { exercise in
                if  let base64String = exercise?.skeleton_image,
                    let uiImage = convertBase64ToImage(base64String: base64String) {
                    DispatchQueue.main.async { [self] in
                        self.uiimage = uiImage
                    }
                }
                else {
                    print("exercise is nil")
                }
            }

    }
    
    func convertBase64ToImage(base64String: String) -> UIImage? {
            guard let data = Data(base64Encoded: base64String) else {
                return nil
            }
            
            guard let uiImage = UIImage(data: data) else {
                return nil
            }
            
            return uiImage
        }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
