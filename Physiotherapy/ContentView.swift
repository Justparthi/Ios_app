//
//  ContentView.swift
//  BodyMeasurementTool
//
//  Created by george kaimoottil on 22/10/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        storyboardview().edgesIgnoringSafeArea(.all)
        
    }
}

#Preview {
    ContentView()
}

struct storyboardview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(identifier: "ViewController")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
