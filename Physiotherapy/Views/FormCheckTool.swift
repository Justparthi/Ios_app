//
//  File.swift
//  FormCheckToolView
//
//  Created by Yash Patil on 06/11/23.
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
        guard session.inputs.first is AVCaptureDeviceInput else {
            return
        }
        
        if(!session.inputs.isEmpty) {
            let captureDevice: AVCaptureDeviceInput? = session.inputs.last as? AVCaptureDeviceInput
            if(captureDevice != nil) {
                session.removeInput(captureDevice!)
                let position: AVCaptureDevice.Position = (captureDevice!.device.position == .back) ? .front : .back
                let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position)
                
                if let device = discoverySession.devices.first {
                    do {
                        let input = try AVCaptureDeviceInput(device: device)
                        session.addInput(input)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Device not found")
            }
            
            session.commitConfiguration()
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    
                    // BACKGROUND
                    Group {
                        RoundedRectangle(cornerRadius: 40)
                            .foregroundStyle(Color(uiColor: UIColor(hex: "6B645D", alpha: 1.0)!))
                            .frame(width: 395, height: 270)
                            .padding(.top, 570)
                        
                        RoundedRectangle(cornerRadius: 20).frame(width: 228, height: 62)
                            .foregroundStyle(Color(uiColor: UIColor(hex: "6B645D", alpha: 1.0)!)).shadow(radius: 5)
                            .padding(.bottom, 600)
                        VStack {
                            Text("Camera is ON")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("newOrange"))
                            Text("You're being recorded!")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                        }.padding(.bottom, 600)
                        
                        if isCameraEnabled {
                            CameraViewController(session: $recorder.session)
                                .frame(width: geo.size.width, height: geo.size.height * 0.6) // Adjust size as needed
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
                                if (isCameraEnabled) {
                                    self.toggleCamera(session: self.recorder.session)
                                }
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                                    .foregroundStyle(.white)
                            }
                        }.frame(width: 33, height: 33)
                            .padding(.top, -330)
                            .padding(.leading, 330)
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            print("Close button tapped")
                            
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("newOrange"))
                                .padding(.bottom, 330)
                            
                        }
                        .frame(width: 33, height: 33, alignment: .topLeading)
                        .padding(.trailing, 330)
                        .fontWeight(.heavy)
                        .padding(.top, -330)
                        .onTapGesture {
                            isShowingFormCheckTools = false
                        }
                    }
                    
                    ZStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20).frame(width: 325, height: 95)
                                .foregroundColor(.white).shadow(radius: 5)
                            HStack {
                                Text("Time")
                                    .font(.custom("cabin", size: 24))
                                    .foregroundStyle(.black)
                                Spacer()
                                Text("\(formatElapsedTime(elapsedTime))")
                                    .foregroundStyle(.black)
                                    .font(.custom("raleway", size: 26))
                            }
                            .frame(width: 300, height: 80)
                        }
                        .padding(.top, 480)
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
                        Group {
                            Button(action: {
                                let _status = AVCaptureDevice.authorizationStatus(for: .video)
                                var _permitted = false
                                
                                if (_status == .authorized) {
                                    _permitted = true
                                }
                                
                                if (!_permitted) {
                                    AVCaptureDevice.requestAccess(for: AVMediaType.video) { _status in
                                        _permitted = _status
                                    }
                                }
                                
                                if (_permitted) {
                                    startTimer()
                                    recorder.startRecording()
                                    withAnimation(.spring()) {
                                        isStarted.toggle()
                                        currentOffset = 0
                                    }
                                    self.isStopDisabled = false
                                }
                            }, label: {
                                if isStarted {
                                    HStack(spacing: 15) {
                                        Image(systemName: "play.circle")
                                            .font(.title)
                                            .foregroundStyle(Color.black)
                                        Text("Start")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.black)
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 20)
                                    .padding()
                                    .background(orangeColor)
                                    .cornerRadius(20)
                                    
                                } else {
                                    HStack {
                                        Image(systemName: "pause.circle.fill")
                                            .font(.title)
                                        Text("Pause")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundStyle(Color(.customColor2))
                                    .frame(width: 150, height: 45)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundStyle(.white))
                                }
                            }).padding(.top, 680)
                                .padding(.trailing, 180)
                            
                            Button(action: {
                                stopTimer()
                                if let recordedVideoURL = recorder.recordedVideoURL {
                                    VideoUploader.uploadVideo(videoURL: recordedVideoURL) { success, message in
                                        if success {
                                            print(message ?? "Upload successful!")
                                        } else {
                                            print("Upload failed: \(message ?? "Unknown error")")
                                        }
                                    }
                                } else {
                                    print("Recorded video URL is not available")
                                }
                                isWorkoutSuccessfulBox = true
                                recorder.stopRecording()
                            }, label: {
                                Image("stop")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 20)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(20)
                            })
                            .disabled(self.isStopDisabled)
                            .padding(.top, 680)
                            .padding(.leading, 190)
                        }
                        
                        if isWorkoutSuccessfulBox {
                            WorkoutSuccessfulBox()
                        }
                    }.padding(.top, 30)
                        .fullScreenCover(isPresented: $isProfileViewPresented) {
                            Physiotherapy(selectedTab: 4)
                        }
                }.background {
                    ZStack {
                        Color(red: 0.13, green: 0.13, blue: 0.13)
                            .ignoresSafeArea(.all)
                        
                        Ellipse()
                            .foregroundColor(.clear)
                            .frame(width: 523, height: 563)
                            .background(Color(red: 1, green: 0.74, blue: 0.51).opacity(0.39))
                            .blur(radius: 700)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }
        }
    }
    
    // Elapsed Time
    func formatElapsedTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60 % 60
        let hours = Int(time) / 3600
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // Start the Timer
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            elapsedTime += timer!.timeInterval
        }
    }
    
    // Stop the Timer
    func stopTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
}

struct WorkoutSuccessfulBox: View {
    @State private var isProfileViewPresented = false
    
    var body: some View {
        VStack {
            Text("Workout Successful!")
                .font(.largeTitle)
                .padding()
            Button(action: {
                isProfileViewPresented = true
            }) {
                Text("Go to Profile")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
}
