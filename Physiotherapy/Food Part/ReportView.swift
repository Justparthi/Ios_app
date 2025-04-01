//
//  ReportView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 20/10/23.
//

import SwiftUI
import Charts

enum Day: String {
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
}

struct ReportView: View {
    
    let calories: [Int] = [250, 520, 1000 ,1300]
    let time: [String] = ["11 AM", "1 PM", "3 PM", "5 PM", "7 PM"]
    
    @State var selection: Day = .today
    var body: some View {
        
        VStack(spacing: 30) {
            
            Text("Report")
                .font(.title2)
                .fontWeight(.semibold)
            
            Picker(selection: $selection) {
                Text(Day.today.rawValue)
                    .tag(Day.today)
                
                Text(Day.thisWeek.rawValue)
                    .tag(Day.thisWeek)
                
                Text(Day.thisMonth.rawValue)
                    .tag(Day.thisMonth)
            } label: {
                
            }
            .pickerStyle(.segmented)
            
            Text("1245 calories consumed")
            
            Chart(0..<calories.count, id: \.hashValue) { i in
                BarMark(
                    x: .value("Time", time[i]),
                    y: .value("calories", calories[i]))
            }
            .frame(height: 200)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("orangeColor"))
    }
}

#Preview {
    ReportView()
}
