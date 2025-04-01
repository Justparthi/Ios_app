//
//  Home.swift
//  Physiotherapy
//
//  Created by Shagun on 17/05/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage
import Charts

@Observable class HomeVM: ObservableObject {
    var userName: String = "No name"
    var heartRate: String = ""
    var userProfilePhotoPath: String = ""
    var retrievedUserPhoto: UIImage? = UIImage(named: "userImage")!
    var user: User? = nil
    let firestore = Firestore.firestore().collection("Users")
    let db = Database.database().reference().child("Activity Tracker")
    var activity: Activity? = nil

    init() {
        if let user = Auth.auth().currentUser {
            self.user = user
           
            firestore
                .whereField("userId", isEqualTo: user.uid)
                .getDocuments { snapshot, _ in
                    if let snapshot {
                        for doc in snapshot.documents {
                            let data = doc.data()
                            self.userName = data["userName"] as? String ?? "No name"
                        }
                    }
                }
            getData()
        }
    }
   
    func getData() {
        if let user = self.user {
            db.child(user.uid)
                .observe(.childAdded) { snapshot in
                    do {
                        let activity = try snapshot.data(as: Activity.self)
                        self.activity = activity
                    } catch let error {
                        print("Error: \(error)")
                    }
                }
        }
    }
    
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
}

struct BoxView: View {
    var title: String
    var value: String
    var image: String
    var boxColor: String = ""
    let progress: String
    let currentDate = Date()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM "
        return formatter
    }()
    let options = ["Week 1", "Week 2", "Week 3", "Week 4"]
    let dataPoints: [Double] = [10, 5, 12, 8, 15, 6, 9]
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 17)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.73),brownColor,brownColor]), startPoint: .topLeading, endPoint: .trailing))
                .frame(width: 105, height: 140)
            
            VStack {
                HStack {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.white)
                    Image(systemName: image)
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.white)
                }.padding(.bottom)
                
                
                GeometryReader { geometry in
                    ZStack {
                        Circle()
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        Circle()
                            .trim(from: 0, to: CGFloat(Double((progress))!))
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.5), value: UUID())
                        
                        VStack {
                            Text(progress)
                                .font(.system(size: 10))
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("\(value)")
                                .font(.system(size: 10))
                                .bold()
                                .foregroundColor(.white)
                        }
                        
                    }
                    .frame(width: 100)
                }.frame(width: 100,height: 60)
            }
        }
    }
}

struct WorkoutData: Identifiable {
    let id = UUID()
    let day: String
    let hours: Double
}

let workoutData: [WorkoutData] = [
    WorkoutData(day: "Sun", hours: 6),
    WorkoutData(day: "Mon", hours: 8),
    WorkoutData(day: "Tues", hours: 8),
    WorkoutData(day: "Wed", hours: 0),
    WorkoutData(day: "Thu", hours: 4),
    WorkoutData(day: "Fri", hours: 2),
    WorkoutData(day: "Sat", hours: 4)
]


struct Home: View {
    @StateObject var vm: HomeVM = HomeVM()
    @State private var selectedOption = 0
    @State private var isPresented = false
    @State private var isPresented2 = false
    @State private var isPresented3 = false
    
    @State private var showProfileModal = false
    @Binding var userName: String
    @Binding var retrievedUserPhoto: UIImage?
    @Binding var userProfilePhotoPath: String
    
    init(userName: Binding<String>, retrievedUserPhoto: Binding<UIImage?>, userProfilePhotoPath: Binding<String>) {
        self._userName = userName
        self._retrievedUserPhoto = retrievedUserPhoto
        self._userProfilePhotoPath = userProfilePhotoPath
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    @ViewBuilder
    private var profileImageView: some View {
        if let retrievedUserPhoto = retrievedUserPhoto,
           retrievedUserPhoto != UIImage(named: "userImage") {
            Image(uiImage: retrievedUserPhoto)
                .resizable()
                .clipShape(Circle())
                .frame(width: 35, height: 35)
                .onTapGesture {
                    showProfileModal = true
                }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(Color("newOrange"))
                .onTapGesture {
                    showProfileModal = true
                }
        }
    }
    
    let options = ["Week 1", "Week 2", "Week 3", "Week 4"]
    var brownColor: Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    ScrollView { // Make content scrollable
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(red: 0.18, green: 0.18, blue: 0.18))
                                        .frame(width: 350, height: 100)
                                        .padding(.top, 10)
                                    VStack {
                                        Text("Great!")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .padding(.top, 20)
                                            .padding(.horizontal, 20)
                                            .foregroundStyle(Color("newOrange"))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("Halfway through today's plan. Keep going!")
                                            .font(.headline)
                                            .foregroundColor(Color(white: 150.0/255.0))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .padding(.top, -22)
                                    }
                                }
                            }
                            
                            Text("Activity Reports")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 10)
                                .padding(.leading, 10)
                                .foregroundColor(Color("newOrange"))
                            
                            HStack(spacing: 18) {
                                Button(action: { isPresented = true }) {
                                    BoxView(title: "Heartbeat", value: "bpm", image: "heart.fill", progress: String(format: "%.0f", vm.activity?.HeartRate ?? 80))
                                }
                                .sheet(isPresented: $isPresented) { HeartTracker() }
                                
                                Button(action: { isPresented2 = true }) {
                                    BoxView(title: "Weight", value: "kg", image: "scalemass.fill", progress: "34")
                                }
                                .sheet(isPresented: $isPresented2) { Weight_Tracker() }
                                
                                Button(action: { isPresented3 = true }) {
                                    BoxView(title: "VO2", value: "Superior", image: "heart.square.fill", progress: "12")
                                }
                                .sheet(isPresented: $isPresented3) { VO2Tracker() }
                            }
                            .padding(.top, -15)
                            .padding(.leading, 10)
                        }
                        .padding([.leading, .trailing], 10)
                        HStack {
                            Text("Exercise")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 10)
                                .padding(.leading, 20)
                                .foregroundColor(Color("newOrange"))

                            Spacer() // Adds flexible space between Text and Picker

                            Picker(selection: $selectedOption, label: Text(options[selectedOption])) {
                                ForEach(0 ..< options.count, id: \.self) { index in
                                    Text(options[index])
                                        .foregroundColor(Color("newOrange"))
                                }
                            }
                            .pickerStyle(.automatic)
                            .accentColor(Color("newOrange"))
                            .padding(.top, 8)
                        }
                        Chart(workoutData) { data in
                            LineMark(
                                x: .value("Day", data.day),
                                y: .value("Hours", data.hours)
                            )
                            .foregroundStyle(Color("newOrange"))
                            .lineStyle(StrokeStyle(lineWidth: 2))
                        }
                        .chartYAxis {
                            AxisMarks(values: [0, 2, 4, 6, 8]) { value in
                                AxisValueLabel {
                                    if let yValue = value.as(Double.self) {
                                        Text("\(yValue, specifier: "%.0f")")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: workoutData.map { $0.day }) { value in
                                AxisValueLabel {
                                    if let day = value.as(String.self) {
                                        Text(day)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                }
                            }
                        }

                        .frame(height: 200) // Adjust the height as needed
                        .padding(.horizontal)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background {
                        ZStack {
                            Color(red: 0.13, green: 0.13, blue: 0.13)
                                .ignoresSafeArea(.all)
                        }
                    }
                }
                .navigationTitle("Hey! \(userName)")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(trailing: profileImageView)
                .sheet(isPresented: $showProfileModal) {
                    Profile(retrievedUserPhoto: $retrievedUserPhoto, userProfilePhotoPath: $userProfilePhotoPath, userName: $userName)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(
            userName: .constant("Nakshatra Verma"),
            retrievedUserPhoto: .constant(nil),
            userProfilePhotoPath: .constant("")
        )
    }
}
