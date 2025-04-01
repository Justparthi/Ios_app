//
//  ContentView.swift
//  videoRecorder
//
//  Created by george kaimoottil on 05/11/23.
//

import AVFoundation
import Photos
import SwiftUI

struct CameraViewController: UIViewControllerRepresentable {
    @Binding var session: AVCaptureSession
    
    class Coordinator: NSObject {
        var parent: CameraViewController
        
        init(parent: CameraViewController) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        controller.view.layer.addSublayer(previewLayer)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            if let layer = uiViewController.view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
                layer.session = session
                layer.videoGravity = .resizeAspectFill

                layer.frame = CGRect(
                    x: uiViewController.view.bounds.origin.x + 10,
                    y: uiViewController.view.bounds.origin.y + 10,
                    width: uiViewController.view.bounds.width - 20,
                    height: uiViewController.view.bounds.height - 20
                )
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var recorder: Recorder
    
    var body: some View {
        VStack {
            CameraViewController(session: $recorder.session)
                            .frame(height: 300)
                            .padding(10)
            HStack {
                Button(action: {
                    recorder.startRecording()
                }) {
                    Text("Start Recording")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(recorder.isRecording)
                
                Button {
                    recorder.stopRecording()
                } label: {
                    Text("Stop Recording")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!recorder.isRecording)
            }
            
            if recorder.isRecording {
                Text("Recording...")
                    .foregroundColor(.red)
            }
        }
    }
}
