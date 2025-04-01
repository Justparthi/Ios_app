
//  ExerciseTab.swift
//  Physiotherapy
//
//  Created by Shagun on 16/05/23.
//
//  ExerciseTab.swift
//  Analysed_Figma
//
//  Created by Chetan Choudhary on 30/06/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

@MainActor
final class ExerciseTabViewModel: ObservableObject{
    @Published private(set) var user: authDataResultModel? = nil
    @Published var exercises = [fetchExercise]()
    @Published var bothDaysAndExercise: [String : [fetchExercise]] = [:]
    let userId = Auth.auth().currentUser?.uid
    
    func loadCurrentUser() throws {
        self.user = try AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    //    func fetchExercises() {
    //        let ref = Database.database().reference()
    //        ref.child("assignedExcercise/\(userId!)/exercises").observe(.value) { parentSnapshot in
    //            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
    //                return
    //            }
    //            self.exercises = children.compactMap { snapshot in
    //                guard let exercise = try? snapshot.data(as: fetchExercise.self) else {
    //                    return nil
    //                }
    //                print("-----------all data: ", snapshot)
    //                return exercise
    //            }
    //        }
    //    }
    
    func fetchExercises() {
        let ref = Database.database().reference()
        ref.child("assignedExcercise/\(userId!)/exercises").observe(.value) { parentSnapshot in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            self.bothDaysAndExercise.removeAll()
            for snapshot in children {
                if let exercise = try? snapshot.data(as: fetchExercise.self) {
                    if var exercisesForDay = self.bothDaysAndExercise[exercise.assignedDay] {
                        exercisesForDay.append(exercise)
                        self.bothDaysAndExercise[exercise.assignedDay] = exercisesForDay
                    } else {
                        self.bothDaysAndExercise[exercise.assignedDay] = [exercise]
                    }
                }
            }
        }
    }
}

struct fetchExercise: Encodable,Decodable, Hashable {
    var Exercise_Name: String = ""
    var assignedDay: String = ""
    //var caloriesBurnPerMin: String = ""
    var id: String = ""
}

extension Encodable {
    var toDictionary: [String:Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any]
    }
}

struct ExerciseTab: View {
   @StateObject var vm: HomeVM=HomeVM()
    @StateObject var viewModel = ExerciseTabViewModel()
    let imageNames = ["crunches", "squats", "squats2", "pushups"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    @State private var selectedExercise: [fetchExercise]?
    @State private var selectedIndex: Int? = 0
    
    @Binding var userName:String
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("Hey \(userName)!").font(.title3).bold().foregroundColor(Color("newOrange"))
                        
                        Text("Pick a workout")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color("newOrange"))
                    }.padding(20)
                    
                    VStack(spacing:20) {
                        if !viewModel.bothDaysAndExercise.isEmpty {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(viewModel.bothDaysAndExercise.sorted(by: { $0.key < $1.key }), id: \.key) { day, exercises in
                                    
                                    ExerciseButton(days: day, onTap: {
                                        selectedExercise = exercises
                                    }, selectedExercise: $selectedExercise, selectedIndex: $selectedIndex)
                                }
                            }
                            .onAppear {
                                selectedExercise = selectedExercise
                            }
                            .padding([.leading, .trailing], 20)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 33) {
                                if let selectedExercise = selectedExercise {
                                    ForEach(selectedExercise, id: \.self) { buttons in
                                        imageBox(name: buttons.Exercise_Name)
                                    }
                                }
                            }
                            
                        } else {
                            Text("No exercises are assigned")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.top, 10)
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
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
            
            .onAppear{
                
            
                try? viewModel.loadCurrentUser()
                viewModel.fetchExercises()
                
            }
        }
    }
}


struct ExerciseButton: View {
    let days: String
    let onTap: () -> Void
    @Binding var selectedExercise: [fetchExercise]?
    @Binding var selectedIndex: Int?
    
    var body: some View {
        Button(action: {
            onTap()
            selectedIndex = selectedExercise?.firstIndex { $0.assignedDay == days }
        }) {
            Text(days)
                .font(.custom("Raleway", size: 14))
                .foregroundColor(((selectedExercise?.firstIndex(where: { $0.assignedDay == days })) != nil) ?  Color.white : Color("newOrange"))
                .frame(width: 80, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(selectedIndex != nil && selectedIndex == selectedExercise?.firstIndex(where: { $0.assignedDay == days }) ? Color("newOrange") : Color.white)
                        .shadow(radius: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            onTap()
        }
    }
}






struct imageBox: View {
    @State private var likeButton = false
    var name: String
    @State private var isPresentingSecondView = false
    
    //  var calories: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
                .frame(width: 150, height: 220)
                .shadow(radius: 3)
            
            Image("crunches")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 147, height: 217)
                .cornerRadius(15)
                .clipped()
            
            VStack {
                HStack(spacing: 50) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("MyColor2"))
                            .frame(width: 60, height: 25)
                            .shadow(radius: 2)
                        
                        HStack {
                            Image("flame")
                            //                            Text(calories)
                            //                                .font(.caption)
                            //                                .bold()
                            //                                .foregroundColor(Color("CustomColor"))
                        }
                        
                    }
                    .padding(.trailing, 75)
                    
                    //                    ZStack {
                    //                        RoundedRectangle(cornerRadius: 30)
                    //                            .foregroundColor(Color("MyColor2"))
                    //                            .frame(width: 25, height: 25)
                    //                            .shadow(radius: 2)
                    //
                    //                        LikeButton(likeButtonPressed: $likeButton)
                    //                            .frame(width: 21)
                    //                    }
                }
                .padding(.bottom, 130)
                
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color("newOrange"))
                        .frame(width: geo.size.width, height: geo.size.height)
                        .shadow(radius: 2)
                    
                        .overlay(
                            Button(action: {
                                isPresentingSecondView = true
                            }) {
                                Text("\(name)")
                                    .font(.custom("Raleway",size: 14))
                                    .foregroundStyle(Color.black)
                            }
                                .fullScreenCover(isPresented: $isPresentingSecondView) {
                                    Exercise2(exercise: "crunches", selectedName: name)
                                    
                                }
                                .foregroundColor(Color("CustomColor"))
                                .bold()
                        )
                }
                .frame(width: 100,height: 50)
            }
        }
    }
}


//struct ExerciseTab_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseTab(vm: HomeVM())
//    }
//}
