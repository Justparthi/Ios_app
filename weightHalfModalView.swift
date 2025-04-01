//
//  weightHalfModalView.swift
//  Physiotherapy
//
//  Created by Akshat Dutt Kaushik on 07/10/24.
//

import Foundation
import SwiftUI

struct WeightSelectionView: View {
    @Binding var selectedWeight: Double
    @Environment(\.dismiss) var dismiss

    // Create an array of weights from 0 to 200 lbs
    let weights: [Double] = Array(stride(from: 20, through: 400, by: 1))

    var body: some View {
        VStack {
            Text("Select Weight")
                .font(.headline)
                .padding()

            // Picker styled as a wheel
            Picker("Weight", selection: $selectedWeight) {
                ForEach(weights, id: \.self) { weight in
                    Text("\(weight, specifier: "%.1f")lb").tag(weight)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 200)

            Button("Done") {
                dismiss()
            }
            .padding()
        }
        .padding()
    }
}
