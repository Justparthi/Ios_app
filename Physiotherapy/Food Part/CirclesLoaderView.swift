//
//  CirclesLoaderView.swift
//  Physiotherapy
//
//  Created by chirag arora on 21/12/23.
//

import SwiftUI

struct CirclesLoaderView: View {
    @State private var degree = 270
    var count: Int = 13
    
    var body: some View {
        GeometryReader { bounds in
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(.black)
                    .frame(width: getDotSize(i), height: getDotSize(i), alignment: .center)
                    .offset(x: (bounds.size.width / 2) - 12)
                    .rotationEffect(.degrees(.pi * 2 * Double(i * 5)))
            }
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
            .rotationEffect(.degrees(Double(degree)))
            .animation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false),
                value: degree
            )
            .onAppear{
                degree = 270 + 360
            }
        }
        .frame(width: 90, height: 90)
    }
    
    private func getDotSize(_ index: Int) -> CGFloat {
        CGFloat(index)
    }
}
