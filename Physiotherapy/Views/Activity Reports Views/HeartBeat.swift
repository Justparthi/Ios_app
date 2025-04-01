//
//  HeartBeat.swift
//  Physiotherapy
//
//  Created by Shagun on 17/05/23.
//

import SwiftUI
import SwiftUICharts
import Charts
import Firebase
import FirebaseDatabase


struct HeartTracker: View {
    
//    var demoHeartRate: [Double] = [95,80,120,80,130,90,120]
    @StateObject var heartbeat = HeartbeatModel()
    @Environment(\.dismiss) var dismiss
    var progress: CGFloat = 0.6
//    let heartRate: Double = 80
    
    @State private var isPresentingSecondView = false
    @State private var selectedOption = 0
    let options = ["Weekly", "Option 2", "Option 3"]
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    @State private var heartbeats: [[String: Any]] = []
    @State private var fetchedDate: String?
    // Added state variable to store fetched data
    
    let userId = Auth.auth().currentUser?.uid
    
    var body: some View {
        ZStack {
            
//            Image("yellow")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .foregroundColor(Color(red: 0.983, green: 0.979, blue: 0.87))
//                .frame(width: 450,height: 350)
//                .padding(.bottom, 560)
//                .rotationEffect(Angle(degrees: 3))
//                .opacity(5)
            
            VStack{
                HStack(alignment: .center,spacing:10) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward.circle.fill")
                            .resizable()
                            .foregroundColor(Color("newOrange"))
                            .frame(maxWidth: 24, maxHeight: 24)
                    }
                    Text("Measuring Heart Rate")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("newOrange"))
                    Spacer()
                }
                .padding([.leading, .top], 20)
            
               // Spacer()
//                ZStack {
//                    RoundedRectangle(cornerRadius: 35)
//                        .frame(width: 125,height: 47)
//                        .foregroundColor(brownColor)
//
//                    Button("START") {
//                        isPresentingSecondView = true
//                    }.foregroundColor(.white).bold().font(.title3)
//                }
                
                VStack{
                    GradientHeartBeatView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(Color("newOrange"))
                        .cornerRadius(30)
                        .ignoresSafeArea()
                    
                    
                    VStack(spacing: 40) {
                        if let date = fetchedDate {
                            Text(date)
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        HStack(alignment: .top, spacing: 40) {
                            
                            VStack {
                                HStack {
                                    Text("\(String(format: "%d", heartbeat.fetchedHeartbeatLevels.min() ?? 80))")
                                        .font(.title2)
                                    
                                    Text("BPM")
                                        .font(.caption)
                                }
                                .bold()
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                                
                                Text("Minimum HR")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                
                            }
                            
                            VStack {
                                HStack {
                                    
                                    if let lastHeartbeat = heartbeats.last,
                                               let heartbeatValue = lastHeartbeat["heartbeat"] as? Double {
                                                Text("\(String(format: "%.2f", heartbeatValue))")
                                                    .font(.title2)
                                            } else {
                                                Text("N/A")
                                                    .font(.title2)
                                            }
                                            Text("BPM")
                                                .font(.caption)
                                }
                                .bold()
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                                
                                Text("Average HR")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                            
                            VStack {
                                HStack {
                                    Text("\(String(format: "%d", heartbeat.fetchedHeartbeatLevels.max() ?? 160))")
                                        .font(.title2)
                                    Text("BPM")
                                        .font(.caption)
                                }
                                .bold()
                                .foregroundColor(.white)
                                .padding(.bottom,10)
                                
                                Text("Maximum HR")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                
                            }
                            
                        }
                    }
                }
            }
            .padding(.top,40)
                .onAppear {
                    fetchHeartRateData()  // Fetch data when the view appears
                    heartbeat.fetchFilteredHeartbeat()
                }
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
    
    func fetchHeartRateData() {
        guard let userId = userId else {
            return
        }

        let userHeartbeatRef = Database.database().reference().child("HeartBeat Tracker/\(userId)")

        userHeartbeatRef.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                return
            }

            if let heartbeatData = snapshot.value as? [String: Any] {
                // Assuming there can be multiple dates for heartbeats, so using an array
//                var heartbeats: [[String: Any]] = []

                for (date, data) in heartbeatData {
                                if let dateData = data as? [String: Any],
                                   let heartbeat = dateData["heartbeat"],
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

                                                let heartBeatInfo = ["date": finalFormattedDate, "heartbeat": heartbeat]
                                                heartbeats.append(heartBeatInfo)
                                            }
                                        }
                                    }
                                }
                            }

                // Now you have an array of heartbeats, you can process or display them as needed
                self.heartbeats = heartbeats

                if let date = heartbeats.last?["date"] as? String {
                    fetchedDate = date
                }

                print(heartbeats)
            }
        }
    }
    
}

class HeartbeatModel: ObservableObject {
    
    let userId = Auth.auth().currentUser?.uid
    @Published var heartbeatList = [fetchheartbeat]()
    @Published var fetchedHeartbeatLevels = [Int]()
    func fetchFilteredHeartbeat(){
        guard let userId = userId else {
            return
        }
        
        let heartbeatRef = Database.database().reference()
        heartbeatRef.child("HeartBeat Tracker/\(userId)").queryLimited(toLast: 10).observe(.value) { parentSnapshot in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            self.heartbeatList = children.compactMap({ snapshot in
                print("success \(snapshot)")
                if let heartbeatData = try? snapshot.data(as: fetchheartbeat.self) {
                    self.fetchedHeartbeatLevels.append(heartbeatData.heartbeat)
                    return heartbeatData
                }
                return nil
            })
            print("fetched heartbeat values \(self.fetchedHeartbeatLevels)")
        }
    }
}


class fetchheartbeat: Encodable,Decodable {
    var date: String = ""
    var heartbeat: Int = 0
}
extension Encodable {
    var Dictionary1: [String:Any]?{
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any]
    }
}

struct demoHeartRate: Identifiable, Equatable {
    
    let day: Int
    var id: Int { day }
    var heartrate: Int
    
    static var heartrate: [demoHeartRate] {
        [demoHeartRate(day: 20, heartrate: 117),
         demoHeartRate(day: 21, heartrate: 87),demoHeartRate(day: 22, heartrate: 115),demoHeartRate(day: 23, heartrate: 85),demoHeartRate(day: 24, heartrate: 116),demoHeartRate(day: 25, heartrate: 99)]
    }
}


struct GradientHeartBeatView: View {
    
    let HeartRateData = demoHeartRate.heartrate
    
    @StateObject var heartbeat = HeartbeatModel()
    
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.8)]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    
    
    
    var body: some View {
        Chart{
            ForEach(heartbeat.fetchedHeartbeatLevels.indices, id: \.self) { data in
                LineMark(x: .value("day", data+20),
                         y: .value("Heartbeat", heartbeat.fetchedHeartbeatLevels[data]))
                .foregroundStyle(Color("newOrange"))
            }
            .interpolationMethod(.cardinal)
//            .symbol(by: .value("", "HeartRate"))
            
            
            
            
        }
        .background(Color(uiColor: UIColor(hex: "6B645D", alpha: 1.0)!))
        .onAppear {
            heartbeat.fetchFilteredHeartbeat()
        }
        .bold(true)
        .chartXScale(domain: 20...30)
        .chartYScale(domain: Int(heartbeat.fetchedHeartbeatLevels.min() ?? 80)...Int(heartbeat.fetchedHeartbeatLevels.max() ?? 160))
        .chartLegend(.visible)
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
            AxisMarks(values : [80,100,120,140]) {
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
    HeartTracker()
        
}

#Preview {
    GradientHeartBeatView()
        .frame(maxHeight: .infinity, alignment: .top)
}
