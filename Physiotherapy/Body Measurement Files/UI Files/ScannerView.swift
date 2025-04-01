//
//  ContentView.swift
//  BodyMeasurementTool
//
//  Created by george kaimoottil on 22/10/23.
//

import SwiftUI
import UIKit

struct ScannerView: View {
    var body: some View {
        storyboardview()
            .edgesIgnoringSafeArea(.all)
            
    }
}


struct storyboardview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller =  storyBoard.instantiateViewController(withIdentifier: "ViewController")
        let navVC = UINavigationController(rootViewController: controller)
        return navVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

#Preview {
    return ViewController()
}
