//
//  FormCheckToolView.swift
//  Physiotherapy
//
//  Created by admin@33 on 13/12/24.
//


import SwiftUI
import AVFoundation
import Alamofire

struct FormCheckToolView: View {
    @State private var isWorkoutSuccessfulBox = false
    @State var isStarted: Bool = true
    @State var currentOffset: CGFloat = 0
    @State private var isProfileViewPresented = false
    @State private var isShowingFormCheckTools = true
    @State private var elapsedTime: TimeInterval = 0.0
    @State private var timer: Timer? = nil
    @State private var isCameraEnabled = false
    @State private var isStopDisabled = true
    @Environment(\.presentationMode) var presentationMode
    var common = CommomFunctions()
    @ObservedObject var recorder = Recorder()
    
    // Custom Colors
    var brownColor: Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    func toggleCamera(session: AVCaptureSession) {
        guard session.inputs.first is AVCaptureDeviceInput else { return }
        
        if !session.inputs.isEmpty {
            if let captureDevice = session.inputs.last as? AVCaptureDeviceInput {
                session.removeInput(captureDevice)
                let position: AVCaptureDevice.Position = (captureDevice.device.position == .back) ? .front : .back
                let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position)
                
                if let device = discoverySession.devices.first {
                    do {
                        let input = try AVCaptureDeviceInput(device: device)
                        session.addInput(input)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                session.commitConfiguration()
            } else {
                print("Device not found")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    // Background and Camera View
                    VStack {
                        if isCameraEnabled {
                            CameraViewController(session: $recorder.session)
                                .frame(width: geo.size.width, height: geo.size.height * 0.6)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .offset(y: -20)
                        } else {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: geo.size.width, height: geo.size.height * 0.6)
                                .foregroundColor(.black)
                                .overlay(
                                    Text("Camera Disabled")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                )
                                .offset(y: -20)
                        }
                    }
                    
                    // Control Buttons
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                isCameraEnabled.toggle()
                                if isCameraEnabled {
                                    recorder.session.startRunning()
                                } else {
                                    recorder.session.stopRunning()
                                }
                            }) {
                                Image(systemName: !isCameraEnabled ? "video.slash.fill" : "video")
                                    .foregroundColor(.white)
                            }
                            Button(action: {
                                if isCameraEnabled {
                                    self.toggleCamera(session: self.recorder.session)
                                }
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        
                        // Timer Display
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 325, height: 95)
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                            HStack {
                                Text("Time")
                                    .font(.custom("cabin", size: 24))
                                Spacer()
                                Text("\(formatElapsedTime(elapsedTime))")
                                    .font(.custom("raleway", size: 26))
                            }
                            .padding()
                        }
                        
                        // Start/Stop Buttons
                        HStack {
                            Button(action: {
                                let status = AVCaptureDevice.authorizationStatus(for: .video)
                                if status == .authorized {
                                    startTimer()
                                    recorder.startRecording()
                                    withAnimation(.spring()) {
                                        isStarted.toggle()
                                    }
                                    isStopDisabled = false
                                } else {
                                    AVCaptureDevice.requestAccess(for: .video) { granted in
                                        if granted {
                                            startTimer()
                                            recorder.startRecording()
                                            withAnimation(.spring()) {
                                                isStarted.toggle()
                                            }
                                            isStopDisabled = false
                                        }
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: isStarted ? "play.circle" : "pause.circle.fill")
                                        .font(.title)
                                    Text(isStarted ? "Start" : "Pause")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .background(orangeColor)
                                .cornerRadius(20)
                            }
                            .disabled(!isCameraEnabled)
                            
                            Button(action: {
                                stopTimer()
                                if let recordedVideoURL = recorder.recordedVideoURL {
                                    uploadVideo(videoURL: recordedVideoURL)
                                }
                                isWorkoutSuccessfulBox = true
                                recorder.stopRecording()
                            }) {
                                Image("stop")
                                    .resizable()
                                    .frame(width: 120, height: 45)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(20)
                            }
                            .disabled(isStopDisabled)
                        }
                    }
                    
                    // Workout Successful Box
                    if isWorkoutSuccessfulBox {
                        WorkoutSuccessfulBox()
                    }
                }
                .background(Color.gray.ignoresSafeArea())
            }
        }
    }
    
    func formatElapsedTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60 % 60
        let hours = Int(time) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func uploadVideo(videoURL: URL) {
        let endpoint = "https://your-api-endpoint.com/output_video"
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { formData in
            formData.append(videoURL, withName: "file", fileName: "video.mp4", mimeType: "video/mp4")
        }, to: endpoint, headers: headers)
        .response { response in
            switch response.result {
            case .success(let data):
                print("Upload successful: \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
            case .failure(let error):
                print("Upload failed: \(error)")
            }
        }
    }
}
