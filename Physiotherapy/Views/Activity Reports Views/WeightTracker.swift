//
//  WeightTracker.swift
//  Physiotherapy
//
//  Created by Shagun on 28/05/23.
//
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct Weight_Tracker: View {
    
    //MARK: Variables
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    var gradientColor : Color = Color("Gradient")
    
    
    var lowestWeight = "47.3"
    var heighestWeight = "51.3"
    
    @State private var selectedUnit: WeightUnit = .kg
    @State private var sliderValue = 45.00
    var calculatedWeight: String = ""
    var dateSubmitted: String = ""
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var wei = weightM()
    @StateObject private var weightModel = WeightTrackerModel()
    @State private var submittedWeights: [String] = UserDefaults.standard.array(forKey: "submittedWeights") as? [String] ?? []
    @State private var weightDate: String = ""
    @StateObject private var commonFunc = CommomFunctions()
    
    @State private var isPresentingSecondView = false
    
   // @Binding var showDashBoardView: Bool
    
    //    @State private var selectedOption = 0
    //    let options = ["Weekly", "Option 2", "Option 3"]
    //    @State private var value: Double = 0.5
    //    private let tickCount = 60
    //    private let sliderHeight: CGFloat = 4
    //    private let sliderWidth: CGFloat = 300
    
    
    enum WeightUnit {
        case kg
        case lb
    }
    
    // Function to convert weight to the selected unit
    
    
    
    var body: some View {
        //MARK: View Z Stack
        ZStack {
            
            // MARK: View Vertical Stack
            VStack {
                HStack {
                    Button { dismiss() }
                label: {
                    Image(systemName: "chevron.backward.circle.fill")
                        .foregroundColor(Color("newOrange"))
                        .fontWeight(.semibold)
                        .padding(.leading)
                        .font(.title)
                }
                    
                    Text("Weight")
                        .font(.title2)
                        .foregroundStyle(Color("newOrange"))
                        .bold()
                    
                    Spacer()
                }
                .frame(height: 70)
                .padding(.horizontal, 5)
                
                //MARK: Displays Weight
                VStack{
                    HStack{
                        Spacer()
                        Button(action: {
                            selectedUnit = WeightUnit.kg
                        }, label: {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 110, height: 30)
                                .background(brownColor).opacity(0.10)
                                .overlay(
                                    Text("Kg")
                                        .font(.headline)
                                        .underline()
                                )
                            
                        })
                        
                        Button(action: {
                            selectedUnit = WeightUnit.lb
                        }, label: {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 110, height: 30)
                                .background(brownColor).opacity(0.10)
                                .overlay(
                                    Text("lb")
                                        .font(.headline)
                                        .underline()
                                )
                        })
                        
                        Spacer()
                    }.foregroundStyle(Color(uiColor: UIColor(hex: "D9D9D9", alpha: 1.0)!))
                        .padding(.vertical, 10)
                        .padding(.bottom, 10)
                    
                }
                
                
                
                
                //MARK: Weight Slider & Submit button
                
                // Calculate highest and lowest weights
                let highestWeight = submittedWeights.map { convertWeightToKg($0) }.max() ?? 0
                let lowestWeight = submittedWeights.map { convertWeightToKg($0) }.min() ?? 0
                
                // Convert to preferred unit
                let highestWeightFormatted = convertWeightToPreferredUnit(highestWeight)
                let lowestWeightFormatted = convertWeightToPreferredUnit(lowestWeight)
                
                VStack{
                    
                    
                    Text("\(convertWeightToPreferredUnit(sliderValue))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    Slider(value: $sliderValue, in: 0...150, step: 0.5)
                        .accentColor(Color("newOrange"))
                        .padding(.bottom,10)
                    
                    Button(action: {
                        let dailyWeight: String = convertWeightToPreferredUnit(sliderValue)
                        // Update the submittedWeights array before calculating highest and lowest weights
                        submittedWeights.append(dailyWeight)
                        
                        // Calculate highest and lowest weights
                        let highestWeight = submittedWeights.map { convertWeightToKg($0) }.max() ?? 0
                        let lowestWeight = submittedWeights.map { convertWeightToKg($0) }.min() ?? 0
                        
                        // Convert to preferred unit
                        let highestWeightFormatted = convertWeightToPreferredUnit(highestWeight)
                        let lowestWeightFormatted = convertWeightToPreferredUnit(lowestWeight)
                        
                        print("daily weight is calculated: \(dailyWeight)")
                        weightModel.createWeightTrackerSubCollection(
                            userID: UserDefaults.standard.string(forKey: "userID") ?? "",
                            userWeight: dailyWeight,
                            highestWeight: highestWeightFormatted,
                            lowestWeight: lowestWeightFormatted,
                            dateSubmitted: (commonFunc.getCurrentDate()))
                        print(submittedWeights)
                        UserDefaults.standard.set(submittedWeights, forKey: "submittedWeights")
                    }) {
                        Text("Submit")
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color("newOrange"))
                            .cornerRadius(10)
                    }
                    
                }
                .padding(.bottom, 30)
                .padding(.horizontal, 30)
                
                Spacer()
                
                
                
                
                //MARK: Lowest & highest Weight
                VStack {
                    HStack{
                        
                        Spacer()
                        
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(brownColor)
                            .shadow(radius: 10, x: -10, y: 10)
                            .overlay(
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(orangeColor)
                            )
                            .overlay(
                                Image(systemName: "arrow.down.to.line"))
                            .foregroundColor(brownColor)
                        
                        
                        Spacer()
                        
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(brownColor)
                            .shadow(radius: 10, x: -10, y: 10)
                            .overlay(
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(orangeColor)
                            )
                            .overlay(
                                Image(systemName: "arrow.up.to.line"))
                            .foregroundColor(brownColor)
                        
                        
                        Spacer()
                    }
                    
                    HStack{
                        // Lowest Weight
                        VStack{
                            Text(lowestWeightFormatted)
                            Text("Lowest")
                                .font(.caption)
                        }.padding(.horizontal, 50)
                            .foregroundStyle(Color.white)
                        
                        //highest Weight
                        VStack{
                            Text(highestWeightFormatted)
                            Text("Highest")
                            
                                .font(.caption)
                        }.padding(.horizontal, 50)
                            .foregroundStyle(Color.white)
                    }.padding()
                    
                }
                
                
                //MARK: Activity Reports
                
                VStack{
                    
                    //Header Activity Report
                    HStack{
                        
                        Text("Activity Reports")
                            .foregroundColor(Color.white)
                            .font(.title2)
                            .bold()
                        
                        
                        Spacer()
                        
                        //MARK: Commented Weekly Button
                        //                        Button(action: {}) {
                        //                            Text("Weekly")
                        //                                .font(.caption)
                        //                                .foregroundColor(Color.white)
                        //                                .padding(.vertical, 8)
                        //                                .padding(.leading, 10)
                        //                            Image(systemName: "chevron.down")
                        //                                .foregroundColor(Color.white)
                        //                                .padding(.trailing, 10)
                        //                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    
                    ScrollView(.vertical) {
                        VStack {
                            
                            if submittedWeights.isEmpty {
                                ForEach(0..<5) { _ in
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(.white)
                                        .frame(width: 350, height: 50)
                                        .overlay(
                                            HStack{
                                                Image(systemName: "scalemass.fill")
                                                    .font(.title2)
                                                    .foregroundStyle(Color.black)
                                                Spacer()
                                                Text("Submit Weight (Kg/ lbs)").foregroundColor(.black)
                                                    .font(.title3)
                                                Spacer()
                                                
                                            }
                                                .padding()
                                        )
                                        .padding(.horizontal, 10)
                                }
                            }else {
                                ForEach(wei.weightList, id: \.userWeight){ object in
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width: 350, height: 55)
                                            .foregroundStyle(Color.white)
                                        HStack(spacing: 150){
                                            Text("\(object.userWeight)")
                                                .foregroundStyle(Color.black)
                                            Text("\(object.dateSubmitted)")
                                                .foregroundStyle(Color.black)
                                        }
                                        .font(.custom("Raleway", size: 14))
                                    }
                                }
                                .padding(.bottom,-1)
                            }
                            
                        }
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    
                }.background(Color("newOrange"))
                    .cornerRadius(10)
                    .edgesIgnoringSafeArea(.bottom)
            }
            
            Spacer()
            
        }
        .onAppear {
            wei.fetchWeightAndDate()
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
        
        
        
    }
    
    private func convertWeightToKg(_ weight: String) -> Double {
        let weightComponents = weight.components(separatedBy: " ")
        guard let value = Double(weightComponents.first ?? "") else {
            return 0
        }
        
        if weightComponents.count > 1, let unit = weightComponents.last?.lowercased() {
            switch unit {
            case "kg":
                return value
            case "lb":
                // Convert lb to kg (1 lb ≈ 0.453592 kg)
                return value * 0.453592
            default:
                return 0
            }
        }
        
        return 0
    }
    
    private func convertWeightToPreferredUnit(_ weight: Double) -> String {
        switch selectedUnit {
        case .kg:
            return String(format: "%.1f Kg", weight)
        case .lb:
            // Convert kg to lb (1 kg ≈ 2.20462 lb)
            let weightInLb = weight * 2.20462
            return String(format: "%.1f lb", weightInLb)
        }
    }
    
//    private func getDateOfWeight(_ weight: String, completion: @escaping (String) -> Void) {
//        let userid = Auth.auth().currentUser?.uid ?? ""
//        let db = Firestore.firestore()
//        db.collection("Users").document(userid).collection("WeightTracker").whereField("userWeight", isEqualTo: weight).getDocuments { snapshot, _ in
//            if let snapshot = snapshot {
//                for doc in snapshot.documents {
//                    let data = doc.data()
//                    let date = data["dateSubmitted"] as? String ?? "no date"
//                    completion(date)
//                }
//            }
//        }
//    }
    
    private func getDateOfWeight(_ weight: String) -> String {
            var resultDate = ""
            let userid = Auth.auth().currentUser?.uid ?? ""
            let db = Firestore.firestore()
            db.collection("Users").document(userid).collection("WeightTracker").whereField("userWeight", isEqualTo: weight).getDocuments { snapshot, _ in
                if let snapshot = snapshot {
                    for doc in snapshot.documents {
                        let data = doc.data()
                        let date = data["dateSubmitted"] as? String ?? "no date"
                        weightDate = date
                    }
                }
            }
            return weightDate
        }
    
    
}

class weightM: ObservableObject {
    let userid = Auth.auth().currentUser?.uid
    @Published var weightList = [weight]()
    @Published var dw = [String]()
    func fetchWeightAndDate() {
        guard let userid = userid else {return}
        let weightRef = Firestore.firestore()
        weightRef.collection("Users").document("\(userid)").collection("WeightTracker").addSnapshotListener { parentSnapshot, _ in
            guard let documents = parentSnapshot?.documents else {
                print("Error fetching documents")
                return
            }
            self.weightList = documents.compactMap({ snapshot in
                if let weightData = try? snapshot.data(as: weight.self) {
                    self.dw.append(weightData.userWeight)
                    return weightData
                }
                
                return nil
            })
            print("fetched weight are \(self.dw)")
        }
    }
}

class weight: Encodable,Decodable {
    var userWeight: String = ""
    var dateSubmitted: String = ""
}
extension Encodable{
    var Dictionary2: [String:Any]?{
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any]
    }
}
                
  
struct Weight_Tracker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            Weight_Tracker()
        }
    }
}

// MARK: Weekly Weight

struct GetWeeklyWeight: View{
    
    var weeklyWeight: String
    var weekday: String
    var body: some View{
        
        ZStack{
            
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.white)
                .frame(height: 50)
                .edgesIgnoringSafeArea(.bottom)
            
            HStack{
                Image(systemName: "scalemass.fill")
                Text(weeklyWeight)
                Spacer()
                Text(weekday)
            }.padding(.horizontal)
        }
        
        .padding(.horizontal)
        .cornerRadius(20)
    }
}
