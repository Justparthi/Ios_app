//
//  heightHalfModalView.swift
//  Physiotherapy
//
//  Created by Akshat Dutt Kaushik on 07/10/24.
//

import Foundation
import SwiftUI

struct HeightSelectionView: View {
    @Binding var selectedHeight: Double
    @Environment(\.dismiss) var dismiss

    // Create an array of heights from 4.0 to 8.0 ft
    let heights: [Double] = Array(stride(from: 4.0, through: 8.0, by: 0.1))

    var body: some View {
        VStack {
            Text("Select Height")
                .font(.headline)
                .padding()

            // Picker styled as a wheel
            Picker("Height", selection: $selectedHeight) {
                ForEach(heights, id: \.self) { height in
                    Text("\(height, specifier: "%.1f") ft").tag(height)
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
