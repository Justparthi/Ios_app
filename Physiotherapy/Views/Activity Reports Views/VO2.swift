//
//  VO2.swift
//  Physiotherapy
//
//  Created by Shagun on 17/05/23.
//

import SwiftUI
import Charts
import Firebase
import FirebaseDatabase

struct VO2Tracker: View {
    
    var demoVo2Data: [Double] = [97,95,99,92,98,95,99,94,97]
    // Firebase variables
    @State private var vo2Data: [[String: Any]] = []
    @State private var fetchedDate: String?
    @StateObject var vo2 = vo2Model()
    let userId = Auth.auth().currentUser?.uid
    let databaseRef = Database.database().reference()
    
    var progress: CGFloat = 0.6
    @Environment(\.dismiss) var dismiss
    //    @State private var selectedOption = 0
    //    let options = ["Weekly", "Option 2", "Option 3"]
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    var body: some View {
        ZStack{
            //            Image("yellow")
            //                .resizable()
            //                .aspectRatio(contentMode: .fill)
            //                .foregroundColor(Color(red: 0.983, green: 0.979, blue: 0.87))
            //                .frame(width: 450,height: 350)
            //                .padding(.bottom,560)
            //                .rotationEffect(Angle(degrees: 3))
            //                .opacity(5)
            
            VStack {
                HStack(alignment: .center, spacing: 10) {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward.circle.fill")
                            .resizable()
                            .foregroundColor(Color("newOrange"))
                            .frame(maxWidth: 24, maxHeight: 24)
                    }
                    
                    Text("VO2")
                        .font(.title2).bold()
                        .foregroundColor(Color("newOrange"))
                    Spacer()
                }
                .padding([.horizontal, .top], 20)
                
                VStack{
                    GradientVO2View()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(Color("newOrange"))
                        .cornerRadius(30)
                        .ignoresSafeArea()
                    VStack {
                        //                        HStack(spacing: 100){
                        Text("Activity Reports")
                            .foregroundColor(.white)
                            .font(.title2).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        //                            ZStack{
                        //                                RoundedRectangle(cornerRadius: 10)
                        //                                    .frame(width: 85)
                        //                                    .foregroundColor(Color.white)
                        //                                Picker(selection: $selectedOption, label: Text("Select an option")) {
                        //                                    ForEach(0 ..< options.count, id: \.description) {
                        //                                        Text(self.options[$0])
                        //                                    }
                        //                                }
                        //                                .pickerStyle(MenuPickerStyle())
                        //                            }.frame(height: 20)
                        //                        }
                        //                        .padding(.bottom,30)
                        
                        ScrollView {
                            ForEach(vo2.vo2List.reversed(), id: \.oxygenlevel ){ object in
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15).frame(width: 350 ,height: 55).foregroundColor(.white).shadow(radius: 15)
                                    HStack(spacing:170){
                                        
                                        Text("\(object.oxygenlevel) suprior")
                                            .foregroundStyle(Color.black)
                                        if let originalDate = parseDate(object.date) {
                                            Text(formatTimeFromDate(originalDate))
                                                .foregroundStyle(Color.black)
                                        }
                                    }
                                }
                                
                            }
                            
                            
                        }
                        
                        
                        //                        ZStack{
                        //                            RoundedRectangle(cornerRadius: 15).frame(width: 350 ,height: 55).foregroundColor(.white).shadow(radius: 15)
                        //                            HStack(spacing:170){
                        //                                Text("41 suprior").bold()
                        //                                Text("1:00pm")
                        //                            }
                        //                        }
                        //                        ZStack {
                        //                            RoundedRectangle(cornerRadius: 15).frame(width: 350, height: 55).foregroundColor(.white).shadow(radius: 15)
                        //                            HStack(spacing: 100) {
                        //                                if let oxygenLevel = vo2Data.last?["oxygenlevel"] as? Double {
                        //                                    Text("\(String(format: "%.2f", oxygenLevel)) suprior").bold()
                        //                                } else {
                        //                                    Text("N/A suprior") // Display a placeholder or handle the case when data is not available
                        //                                }
                        //                                if let date = fetchedDate {
                        //                                                    Text(date)
                        //                                                        .font(.caption)
                        //
                        //                                                }
                        //                            }
                        //                        }
                        //                        ZStack{
                        //                            RoundedRectangle(cornerRadius: 15).frame(width: 350 ,height: 55).foregroundColor(.white).shadow(radius: 15)
                        //                            HStack(spacing:170){
                        //                                Text("53 suprior").bold()
                        //                                Text("12:00pm")
                        //
                        //                            }
                        //                        }
                        
                        
                    }
                }
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
        }
        .onAppear {
            //                fetchVo2()
            vo2.fetchFilteredVo2()
            
        }
    }
    
    // Function to parse the original date string
    func parseDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy h:mma"
        return dateFormatter.date(from: dateString)
    }
    
    // Function to format the time from a Date object
    func formatTimeFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        return dateFormatter.string(from: date)
    }
    
    func fetchVo2() {
        guard let userId = userId else {
            return
        }
        
        let userHeartbeatRef = Database.database().reference().child("VO2 Tracker/\(userId)")
        
        userHeartbeatRef.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(),
                  let vo2Data = snapshot.value as? [String: Any] else {
                return
            }
            
            var fetchedVo2Data: [[String: Any]] = []
            
            for (date, data) in vo2Data {
                if let dateData = data as? [String: Any],
                   let oxygenLevel = dateData["oxygenlevel"] as? Double,
                   let dateString = date as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    
                    if let originalDate = dateFormatter.date(from: dateString) {
                        dateFormatter.dateFormat = " MMMM yyyy"
                        let formattedDate = dateFormatter.string(from: originalDate)
                        
                        // Convert day to ordinal form (e.g., 1st, 2nd, 3rd, 4th)
                        if let day = Calendar.current.dateComponents([.day], from: originalDate).day {
                            let numberFormatter = NumberFormatter()
                            numberFormatter.numberStyle = .ordinal
                            
                            if let dayOrdinal = numberFormatter.string(from: NSNumber(value: day)) {
                                let finalFormattedDate = "\(dayOrdinal) \(formattedDate)"
                                
                                let vo2Info = ["date": finalFormattedDate, "oxygenlevel": oxygenLevel]
                                fetchedVo2Data.append(vo2Info)
                            }
                        }
                    }
                }
            }
            
            self.vo2Data = fetchedVo2Data
            
            if let date = fetchedVo2Data.last?["date"] as? String {
                fetchedDate = date
            }
            
            print(fetchedVo2Data)
        }
    }
    
}

class vo2Model: ObservableObject {
    
    let userId = Auth.auth().currentUser?.uid
    @Published var vo2List = [fetchvo2]()
    @Published var fetchedOxygenLevels = [Int]()
    func fetchFilteredVo2(){
        guard let userId = userId else {
            return
        }
        
        let vo2Ref = Database.database().reference()
        vo2Ref.child("VO2 Tracker/\(userId)").queryLimited(toLast: 10).observe(.value) { parentSnapshot in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            self.vo2List = children.compactMap({ snapshot in
                print("success \(snapshot)")
                if let vo2Data = try? snapshot.data(as: fetchvo2.self) {
                    self.fetchedOxygenLevels.append(vo2Data.oxygenlevel)
                    return vo2Data
                }
                return nil
            })
            print("fetched oxygen levels \(self.fetchedOxygenLevels)")
        }
    }
}


class fetchvo2: Encodable,Decodable {
    var date: String = ""
    var oxygenlevel: Int = 0
}
extension Encodable {
    var Dictionary: [String:Any]?{
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any]
    }
}

struct demoVO2: Identifiable, Equatable {
    
    let day: Int
    var id: Int { day }
    var oxygenLevel: Int
    
    static var VO2Levels: [demoVO2] {
        [demoVO2(day: 20, oxygenLevel: 97),
         demoVO2(day: 21, oxygenLevel: 89),demoVO2(day: 22, oxygenLevel: 97),demoVO2(day: 23, oxygenLevel: 90),demoVO2(day: 24, oxygenLevel: 94)]
    }
}


struct GradientVO2View: View {
    
    @StateObject var vo2 = vo2Model()
    
    let VO2Data = demoVO2.VO2Levels
    
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.8)]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    
    
    
    var body: some View {
        Chart{
            ForEach(vo2.fetchedOxygenLevels.indices, id: \.self) { data in
                LineMark(x: .value("day", data+20),
                         y: .value("VO2", vo2.fetchedOxygenLevels[data]))
                .foregroundStyle(Color("newOrange"))
            }
            .interpolationMethod(.catmullRom)
            //            .symbol(by: .value("Pet type", "cat"))
            
            
            
        }
        .background(Color(uiColor: UIColor(hex: "6B645D", alpha: 1.0)!))
        .onAppear {
            vo2.fetchFilteredVo2()
        }
        .bold(true)
        .chartYScale(domain: Double(vo2.fetchedOxygenLevels.min() ?? 87)...Double(vo2.fetchedOxygenLevels.max() ?? 100))
        .chartXScale(domain: 20...29)
        .chartLegend(.hidden)
        .chartXAxis {
            AxisMarks( values: [20,21,22,23,24,25,26,27,28,29]) {
                value in
                AxisGridLine()
                AxisTick()
                if let day = value.as(Int.self) {
                    AxisValueLabel(formatte(number: day),
                                   centered: false,
                                   anchor: .center)
                    .foregroundStyle(Color.black)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        
        
        .chartYAxis {
            AxisMarks( values: [90, 92,94,96,98]) {
                value in
                AxisGridLine()
                AxisTick()
                if let day = value.as(Int.self) {
                    AxisValueLabel(formatte(number: day),
                                   centered: false,
                                   anchor: .center)
                    .foregroundStyle(Color.black)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    func formatte(number: Int) -> String {
        let result = NSNumber(value: number)
        return numberFormatter.string(from: result) ?? ""
    }
}


#Preview {
    VO2Tracker()
    
}






