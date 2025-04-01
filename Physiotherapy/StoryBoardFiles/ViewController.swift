/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The implementation of the application's view controller, responsible for coordinating
 the user interface, video feed, and PoseNet model.
*/

import AVFoundation
import UIKit
import VideoToolbox
import UIKit
import ReplayKit
import FirebaseStorage
import Photos
import ARKit
import SwiftUI
import FirebaseDatabase

class ViewController: UIViewController,RPPreviewViewControllerDelegate{
    
    let recorder = RPScreenRecorder.shared()
    let storage = Storage.storage().reference()
    /// The view the controller uses to visualize the detected poses.
    @IBOutlet private var previewImageView: PoseImageView!

    private let videoCapture = VideoCapture()

    private var poseNet: PoseNet!

    /// The frame the PoseNet model is currently making pose predictions from.
    private var currentFrame: CGImage?

    /// The algorithm the controller uses to extract poses from the current frame.
    private var algorithm: Algorithm = .multiple

    /// The set of parameters passed to the pose builder when detecting poses.
    private var poseBuilderConfiguration = PoseBuilderConfiguration()

    private var popOverPresentationManager: PopOverPresentationManager?
    
    private var arSession: ARSession?
    
    var alertController: UIAlertController?
    
    var ref: DatabaseReference!
    var userId: String? // Set this to your user's unique identifier
    // Properties to store measurements and counts
    var waistLengths: [Double] = []
    var heightLengths: [Double] = []
    var leftLegLengths: [Double] = []
    var shoulderLengths: [Double] = []
    var armsLengths: [Double] = []

    // A timer to capture measurements after 5 seconds
    var measurementTimer: Timer?
    
    var heightAverage : Double = 0.0
    var waistAverage : Double = 0.0
    var leftLegAverage : Double = 0.0
    var shoulderAverage : Double = 0.0
    var armsAverage : Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Firebase Realtime Database
        ref = Database.database().reference()
                
        // Assign the user's unique identifier to userId
        userId = "your_user_id_here" // Replace with your actual user identifier
        // For convenience, the idle timer is disabled to prevent the screen from locking.
        UIApplication.shared.isIdleTimerDisabled = true

        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }

        poseNet.delegate = self
        setupAndBeginCapturingVideoFrames()
    }

    @IBAction func onTapRecord(_ sender: Any) {
        recorder.startRecording { error in
            if let error = error {
                print("Error starting recording: \(error.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func onTapStop(_ sender: Any) {
        recorder.stopRecording { [weak self] (previewVC, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error stopping recording: \(error.localizedDescription)")
            }
            
            if let previewVC = previewVC {
                previewVC.previewControllerDelegate = self
                self.present(previewVC, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func intializeARSession(_ sender: Any) {
        // Create the UIAlertController
            alertController = UIAlertController(title: "Please Wait",
                                                message: "Body measurement in progress...(Kindly don't move away from the camera during measuring)",
                                                preferredStyle: .alert)

            // Create an attributed string for the message with smaller text
            let attributedMessage = NSMutableAttributedString(string: "Body measurement in progress...\n")
            let smallerText = NSAttributedString(string: "(Kindly don't move away from the camera during measuring)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 12)]) // Adjust the font size as needed
            attributedMessage.append(smallerText)

            alertController?.setValue(attributedMessage, forKey: "attributedMessage")
            // Add a custom UIAlertAction for the close button
            let stopMeasuringAction = UIAlertAction(title: "Stop Measuring", style: .cancel) { [weak self] (_) in
                // Stop the ARSession
                self?.arSession?.pause()
                self?.arSession = nil // Set the ARSession to nil
                self?.alertController?.dismiss(animated: true, completion: nil)
            }

            // Add the close action to the alert controller
            alertController?.addAction(stopMeasuringAction)

            // Present the UIAlertController
            if let alertController = alertController {
                present(alertController, animated: true, completion: nil)
            }
        // Create and configure the AR session
        arSession = ARSession()
        let configuration = ARBodyTrackingConfiguration()
        arSession?.run(configuration, options: [])

        // Set the ARSession delegate to self
        arSession?.delegate = self
    }
    
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
            print("DEBUG: Here")
            
            // Check if the screen recording was saved to the Photos library
                // Request authorization to access the Photos library
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        // Fetch the most recent video asset from the Photos library
                        let fetchOptions = PHFetchOptions()
                        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                        
                        if let asset = fetchResult.firstObject {
                            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil) { avAsset, _, _ in
                                if let urlAsset = avAsset as? AVURLAsset {
                                    let videoURL = urlAsset.url
                                    
                                    // Now you can use this 'videoURL' for further processing, such as uploading to Firebase Storage.
                                    self.uploadVideoToStorage(videoURL: videoURL) { success in
                                        if success {
                                            print("DEBUG: Video uploaded successfully to Firebase Storage!")
                                        } else {
                                            print("DEBUG: Failed to upload video to Firebase Storage.")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            
            previewController.dismiss(animated: true, completion: nil)
        }
    
    func uploadVideoToStorage(videoURL: URL, completion: @escaping (Bool) -> Void) {
        guard let videoData = try? Data(contentsOf: videoURL) else {
            print("DEBUG: Unable to create video data")
            completion(false)
            return
        }
        
        let fileName = UUID().uuidString + ".mov" // Unique filename
        let videoRef = storage.child("videos/\(fileName)")
        
        let metaData = StorageMetadata()
        metaData.contentType = "video/quicktime"
        
        videoRef.putData(videoData, metadata: metaData) { metadata, error in
            if let error = error {
                print("Error uploading to Firebase Storage: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let metadata = metadata {
                print("Metadata: \(metadata)")
                print("Success: Video Uploaded!")
                completion(true)
            }
        }
    }
    
    private func setupAndBeginCapturingVideoFrames() {
        videoCapture.setUpAVCapture { error in
            if let error = error {
                print("Failed to setup camera with error \(error)")
                return
            }

            self.videoCapture.delegate = self

            self.videoCapture.startCapturing()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        videoCapture.stopCapturing {
            super.viewWillDisappear(animated)
        }
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        // Reinitilize the camera to update its output stream with the new orientation.
        setupAndBeginCapturingVideoFrames()
    }

    @IBAction func onCameraButtonTapped(_ sender: Any) {
        videoCapture.flipCamera { error in
            if let error = error {
                print("Failed to flip camera with error \(error)")
            }
        }
    }

    @IBAction func onAlgorithmSegmentValueChanged(_ sender: UISegmentedControl) {
        guard let selectedAlgorithm = Algorithm(
            rawValue: sender.selectedSegmentIndex) else {
                return
        }

        algorithm = selectedAlgorithm
    }
}

// MARK: - Navigation

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let uiNavigationController = segue.destination as? UINavigationController else {
            return
        }
        guard let configurationViewController = uiNavigationController.viewControllers.first
            as? ConfigurationViewController else {
                    return
        }

        configurationViewController.configuration = poseBuilderConfiguration
        configurationViewController.algorithm = algorithm
        configurationViewController.delegate = self

        popOverPresentationManager = PopOverPresentationManager(presenting: self,
                                                                presented: uiNavigationController)
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = popOverPresentationManager
    }
}

// MARK: - ConfigurationViewControllerDelegate

extension ViewController: ConfigurationViewControllerDelegate {
    func configurationViewController(_ viewController: ConfigurationViewController,
                                     didUpdateConfiguration configuration: PoseBuilderConfiguration) {
        poseBuilderConfiguration = configuration
    }

    func configurationViewController(_ viewController: ConfigurationViewController,
                                     didUpdateAlgorithm algorithm: Algorithm) {
        self.algorithm = algorithm
    }
}

// MARK: - VideoCaptureDelegate

extension ViewController: VideoCaptureDelegate {
    func videoCapture(_ videoCapture: VideoCapture, didCaptureFrame capturedImage: CGImage?) {
        guard currentFrame == nil else {
            return
        }
        guard let image = capturedImage else {
            fatalError("Captured image is null")
        }

        currentFrame = image
        poseNet.predict(image)
    }
}

// MARK: - PoseNetDelegate

extension ViewController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer {
            // Release `currentFrame` when exiting this method.
            self.currentFrame = nil
        }

        guard let currentFrame = currentFrame else {
            return
        }

        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: poseBuilderConfiguration,
                                      inputImage: currentFrame)

        let poses = algorithm == .single
            ? [poseBuilder.pose]
            : poseBuilder.poses

        previewImageView.show(poses: poses, on: currentFrame)
    }
}

extension ViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        for anchor in anchors {
            
            guard let bodyAnchor = anchor as? ARBodyAnchor
            else { return }
            
            let skeleton = bodyAnchor.skeleton
            //bodyAnchor.estimatedScaleFactor
            for (i, joint) in skeleton.definition.jointNames.enumerated() {
                //print(i, joint)
                
                // [10] right_toes_joint
                // [51] head_joint
            }
            //print("Debug1")
            // Append measurements after 5 seconds
            if measurementTimer == nil {
                measurementTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
                    guard let self = self else { return }
                    //print("Debug2")
                    DispatchQueue.main.async{ [weak self] in
                        let toesJointPos = skeleton.jointModelTransforms[10].columns.3.y
                        let headJointPos = skeleton.jointModelTransforms[51].columns.3.y
                        let heightLength = headJointPos - toesJointPos
                        self?.heightLengths.append(Double(heightLength))
                        //print("Height length:\(headJointPos - toesJointPos) meters")       // 1.6570237 m
                        
                        
                        // Get the positions of the left and right shoulder joints
                        if let leftShoulderPosition = bodyAnchor.skeleton.modelTransform(for: .leftShoulder)?.columns.3,
                           let rightShoulderPosition = bodyAnchor.skeleton.modelTransform(for: .rightShoulder)?.columns.3 {
                            
                            // Calculate the distance between the left and right shoulders
                            let shoulderDistance = simd_distance(leftShoulderPosition, rightShoulderPosition)
                            
                            // Convert the distance to a real-world unit if needed (e.g., meters)
                            // Assuming ARKit provides positions in meters
                            let shoulderDistanceInMeters = Double(shoulderDistance)
                            self?.shoulderLengths.append(shoulderDistanceInMeters)
                            //print("Shoulder Distance: \(shoulderDistanceInMeters) meters")
                        }
                        // Calculate waist length
                        if let leftHipPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_upLeg_joint"))?.columns.3,
                           let rightHipPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_upLeg_joint"))?.columns.3 {
                            let waistLength = simd_distance(leftHipPosition, rightHipPosition)
                            self?.waistLengths.append(Double(waistLength))
                            //print("Waist Length: \(waistLength) meters")
                        }
                        // Calculate legs length
                        if let leftUpLegPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_upLeg_joint"))?.columns.3,
                           let rightUpLegPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_upLeg_joint"))?.columns.3,
                           let leftFootPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_foot_joint"))?.columns.3,
                           let rightFootPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_foot_joint"))?.columns.3{
                            
                            let leftLegLength = simd_distance(leftUpLegPosition, leftFootPosition)
                            let rightLegLength = simd_distance(rightUpLegPosition, rightFootPosition)
                            self?.leftLegLengths.append(Double(leftLegLength))
                            //print("Left Leg Length: \(leftLegLength) meters")
                            //print("Right Leg Length: \(rightLegLength) meters")
                        }
                        
                        // Calculate Hand length
                        if let leftHandFingerPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_handMid_3_joint"))?.columns.3,
                           let rightHandFingerPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_handMid_3_joint"))?.columns.3 {
                            let armsLength = simd_distance(leftHandFingerPosition, rightHandFingerPosition)
                            self?.armsLengths.append(Double(armsLength))
                            //print("Arms Length: \(armsLength) meters")
                        }
                        // Calculate and display averages
                        self?.calculateAndDisplayAverages()
                    }
                }
                
            }
        }
    }

        // Calculate and display the average measurements
        func calculateAndDisplayAverages() {
            heightAverage = heightLengths.reduce(0.0, +) / Double(heightLengths.count)
            waistAverage = waistLengths.reduce(0.0, +) / Double(waistLengths.count)
            leftLegAverage = leftLegLengths.reduce(0.0, +) / Double(leftLegLengths.count)
            shoulderAverage = shoulderLengths.reduce(0.0, +) / Double(shoulderLengths.count)
            armsAverage = armsLengths.reduce(0.0, +) / Double(armsLengths.count)

            print("Average Measurements:")
            print("Average Height Length: \(heightAverage) meters")
            print("Average Waist Length: \(waistAverage) meters")
            print("Average Left Leg Length: \(leftLegAverage) meters")
            print("Average Shoulder Length: \(shoulderAverage) meters")
            print("Average Arms Length: \(armsAverage) meters")
            
            // Store measurements in the Realtime Database
            storeBodyMeasurementsInDatabase()
        }
    
    // Function to store body measurements in the Firebase Realtime Database
        func storeBodyMeasurementsInDatabase() {
            guard let userId = userId else {
                print("User ID is not available.")
                return
            }

            let measurements: [String: Any] = [
                "average_height": heightAverage,
                "average_waist": waistAverage,
                "average_left_leg": leftLegAverage,
                "average_shoulder": shoulderAverage,
                "average_arms": armsAverage
            ]

            // Use the userId as part of the reference path to create a unique key for each user
            let measurementsRef = ref.child("body_measurements").child(userId)
            measurementsRef.setValue(measurements)
            print("DEBUG: Successfully Published body measurements to Firebase...")
        }
}
