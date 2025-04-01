//
//  DetailedAnalysis.swift
//  Physiotherapy
//
//  Created by george kaimoottil on 03/12/23.
//

import SwiftUI

struct DetailedAnalysis: View {
    let totalTime: TimeInterval = 3600  // Total time in seconds (1 hour)
        let workoutTime: TimeInterval = 2700  // Workout time in seconds (45 minutes)
        let pausedTime: TimeInterval = 300  // Paused time in seconds (5 minutes)

        var body: some View {
            VStack {
                Text("Detailed Analysis")
                    .font(.title)
                    .padding()
                    .foregroundColor(.black)

                AnalysisRow(title: "Total Time", time: totalTime)
                AnalysisRow(title: "Workout Time", time: workoutTime)
                AnalysisRow(title: "Paused Time", time: pausedTime)
                AnalysisRow(title: "Accuracy", time: pausedTime)

                Spacer()
            }
        }
}

    struct AnalysisRow: View {
        let title: String
        let time: TimeInterval

        var body: some View {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text(time.formattedTimeString())
                    .font(.subheadline)
            }
            .padding()
        }
    }

    extension TimeInterval {
        func formattedTimeString() -> String {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.hour, .minute, .second]
            return formatter.string(from: self) ?? "00:00:00"
        }
    }

#Preview {
    DetailedAnalysis()
}
