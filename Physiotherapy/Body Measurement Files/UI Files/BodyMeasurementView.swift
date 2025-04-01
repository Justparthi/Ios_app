//
//  BodyMeasurementView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 26/10/23.
//

import SwiftUI

struct BodyMeasurementView: View {
    
    @State var isBlur: Bool = true
    @State var blurAmount: Int = 10
    
    var body: some View {
        ZStack {
            ScannerView()
                .blur(radius: CGFloat(blurAmount))
            
            if isBlur {
                VStack {
                    Text("""
    Our technology uses customer photos to extract key body landmarks and generate a 3D model with 86 measurements. It identifies body features like contour, shape, and position, detects body parts (e.g., head, neck, shoulders, forearms, ankles), and captures appearance details like haircut and skin tone.
    """)
                    .font(.body)
                    .foregroundStyle(.black)
                    .padding()
                    .background{ RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(uiColor: UIColor(hex: "D9D9D9", alpha: 1.0)!)) }
                    .frame(width: 350, height: 300)
                    
                    Button {
                        withAnimation(.smooth(duration: 1)) {
                            isBlur = false
                            blurAmount = 0
                        }
                    } label: {
                        VStack(spacing: 15) {
                            Text("Press to Start")
                                .fontWeight(.semibold)
                            Image(systemName: "camera.fill")
                                .font(.title2)
                        }.tint(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color("newOrange")))
                    }
                }
            }
        }
    }
}

#Preview {
    BodyMeasurementView()
}
