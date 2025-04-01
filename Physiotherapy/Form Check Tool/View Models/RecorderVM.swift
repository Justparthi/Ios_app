//
//  File.swift
//  videoRecorder
//
//  Created by Yash Patil on 06/11/23.
//

import Foundation
import SwiftUI
import AVFoundation
import Photos
import Alamofire

class Recorder: NSObject, AVCaptureFileOutputRecordingDelegate, ObservableObject {
    
    @Published var count = 0
    @Published var exercise: Exercise?
    @Published var fetchedExercise: Exercise?
    @Published var presented: Bool = false
    @Published var session = AVCaptureSession()
    @Published var isRecording = false
    @Published var recordedVideoURL: URL?
    
    private let movieOutput = AVCaptureMovieFileOutput()
    private var frameCaptureTimer: Timer?
    private var shouldCaptureFrames = false
    
    override init() {
        super.init()
        addAudioInput()
        addVideoInput()
        
        if session.canAddOutput(movieOutput) {
            session.addOutput(movieOutput)
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    private func addAudioInput() {
        guard let device = AVCaptureDevice.default(for: .audio) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        if session.canAddInput(input) {
            session.addInput(input)
        }
    }
    
    private func addVideoInput() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        if session.canAddInput(input) {
            session.addInput(input)
        }
    }
    
    func startRecording() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("form_check.mp4") else { return }
        if movieOutput.isRecording == false {
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(at: url)
            }
            movieOutput.startRecording(to: url, recordingDelegate: self)
            isRecording = true
        }
    }
    
    func stopRecording() {
        if movieOutput.isRecording {
            movieOutput.stopRecording()
            isRecording = false
        }
    }
    
    func flipCamera() {
        guard let currentInput = session.inputs.first(where: {$0 is AVCaptureDeviceInput}) as? AVCaptureDeviceInput else { return }
        let currentPosition = currentInput.device.position
        let newPosition: AVCaptureDevice.Position = (currentPosition == .front) ? .back : .front
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else { return }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newDevice)
            session.removeInput(currentInput)
            if session.canAddInput(newInput) {
                session.addInput(newInput)
            } else {
                print("Error cannot add video input to session")
            }
        } catch {
            print("Error switching the camera: \(error.localizedDescription)")
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording: \(error.localizedDescription)")
            return
        }

        // Save video to Photos
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }) { saved, error in
            if saved {
                print("Successfully saved video to Photos.")
                
                // Call VideoUploader to upload the recorded video
                VideoUploader.uploadVideo(videoURL: outputFileURL) { success, message in
                    if success {
                        print("Upload successful! Server response: \(message ?? "No response message")")
                    } else {
                        print("Upload failed: \(message ?? "Unknown error")")
                    }
                }
            } else if let error = error {
                print("Error saving video to Photos: \(error.localizedDescription)")
            }
        }
    }
}

