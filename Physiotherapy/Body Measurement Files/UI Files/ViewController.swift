import AVFoundation
import FirebaseAuth
import UIKit
import VideoToolbox
import UIKit
import ReplayKit
import FirebaseStorage
import Photos
import ARKit
import SwiftUI
import FirebaseDatabase
import FirebaseFirestore
import Alamofire

class ViewController: UIViewController, RPPreviewViewControllerDelegate{
    
    let recorder = RPScreenRecorder.shared()
    let storage = Storage.storage().reference()
    private var previewImageView = PoseImageView(frame: .zero)

    var viewResultButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .borderedProminent()
        button.setTitle("View Result", for: .normal)
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let videoCapture = VideoCapture()

    private var poseNet: PoseNet!

    private var currentFrame: CGImage?

    private var algorithm: Algorithm = .multiple

    private var poseBuilderConfiguration = PoseBuilderConfiguration()

    private var popOverPresentationManager: PopOverPresentationManager?
    
    private var arSession: ARSession?
    
    var alertController: UIAlertController?
    
    var firestore: Firestore!
    var userId: String?
    var waistLengths: [Double] = []
    var heightLengths: [Double] = []
    var leftLegLengths: [Double] = []
    var shoulderLengths: [Double] = []
    var armsLengths: [Double] = []
    var measurementTimer: Timer?
    
    var heightAverage : Double = 0.0
    var waistAverage : Double = 0.0
    var legAverage : Double = 0.0
    var shoulderAverage : Double = 0.0
    var armsAverage : Double = 0.0
    
    var timerLabel: UILabel!
    var countdownTimer: Timer!
    var timeRemaining = 5 // Countdown from 5 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firestore = Firestore.firestore()
        do {
            let user = try AuthenticationManager.shared.getAuthenticatedUser()
            userId = user.uid

        }catch let error {
            print("Error fetching the user uid: \(error.localizedDescription)")
        }
        UIApplication.shared.isIdleTimerDisabled = true

        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
        
        view.backgroundColor = UIColor(hex: "292624", alpha: 1.0)
        
        view.addSubview(previewImageView)
        view.addSubview(viewResultButton)
        view.addSubview(backButton)
        
        backButton.tintColor = .orange
        viewResultButton.layer.cornerRadius = 25
        viewResultButton.configuration?.baseBackgroundColor = .orange
                
        previewImageView.layer.cornerRadius = 12
        previewImageView.layer.masksToBounds = true
        previewImageView.clipsToBounds = true
        previewImageView.backgroundColor = .lightGray
        
        navigationController?.navigationBar.isHidden = true
        
        viewResultButton.addTarget(self, action: #selector(startCountdown), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        constraints()
        
        timerLabel = UILabel()
                timerLabel.frame = CGRect(x: 100, y: 150, width: 200, height: 50)  // You can adjust position
                timerLabel.text = "Starting in 5s"
                timerLabel.textAlignment = .center
                timerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                self.view.addSubview(timerLabel)

        poseNet.delegate = self
        
        setupAndBeginCapturingVideoFrames()
    }
    
    func constraints() {
        
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            previewImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            previewImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            previewImageView.heightAnchor.constraint(equalToConstant: 600),
            
            viewResultButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewResultButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.bottomAnchor.constraint(equalTo: previewImageView.topAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
        ])
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
    
    @objc func segueToManual() {
        let addManualVC = UIHostingController(rootView: ManualMeasurementView())
        navigationController?.pushViewController(addManualVC, animated: true)
    }
    
    @objc func cameraTapped() {
        videoCapture.flipCamera { error in
            if let error {
                print("Failed to flip camera with error \(error)")
            }
        }
    }
    
    @objc func backTapped() {
        let profileVC = UIHostingController(rootView: Physiotherapy(selectedTab: 4))
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func startCountdown() {
        // Disable the AR session if already active
        arSession?.pause()
        
        // Reset the countdown
        timeRemaining = 5
        timerLabel.text = "Starting in 5s"
        
        // Start the timer that counts down every 1 second
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    // Update the countdown and handle the start of AR session
    @objc func updateCountdown() {
        // Decrement the time remaining
        timeRemaining -= 1
        
        // Update the label text
        if timeRemaining > 0 {
            timerLabel.text = "Starting in \(timeRemaining)s"
        } else {
            timerLabel.text = "Starting AR Session!"
            countdownTimer.invalidate()  // Stop the timer
            intializeARSession()  // Start AR session
        }
    }
    
    @objc func intializeARSession() {
        let attributedMessage = NSMutableAttributedString(string: "Body measurement in progress...\n")
        let smallerText = NSAttributedString(string: "(Kindly don't move away from the camera during measuring)",
                                             attributes: [.font: UIFont.systemFont(ofSize: 12)]) // Adjust the font size as needed
        attributedMessage.append(smallerText)
        let _ = UIAlertAction(title: "Stop Measuring", style: .cancel) {  (_) in
        }
        
        self.arSession?.pause()
        self.arSession = nil
        arSession = ARSession()
        let configuration = ARBodyTrackingConfiguration()
        arSession?.run(configuration, options: [])
        arSession?.delegate = self
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        print("DEBUG: Here")
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                
                if let asset = fetchResult.firstObject {
                    PHImageManager.default().requestAVAsset(forVideo: asset, options: nil) { avAsset, _, _ in
                        if let urlAsset = avAsset as? AVURLAsset {
                            let videoURL = urlAsset.url
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
            print("Unable to create video data")
            completion(false)
            return
        }
        
        // Example using Alamofire for uploading
        let storageRef = Storage.storage().reference()
        let fileName = UUID().uuidString + ".mov"
        let videoRef = storageRef.child("videos/\(fileName)")
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(videoData, withName: "video", fileName: fileName, mimeType: "video/quicktime")
        }, to: videoRef.fullPath).response { response in
            if let error = response.error {
                print("Error uploading video: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Video uploaded successfully")
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
        setupAndBeginCapturingVideoFrames()
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
            for (_, _) in skeleton.definition.jointNames.enumerated() {
            }
            if measurementTimer == nil {
                measurementTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
                    guard let self = self else { return }
                    DispatchQueue.main.async{ [weak self] in
                        let toesJointPos = skeleton.jointModelTransforms[10].columns.3.y
                        let headJointPos = skeleton.jointModelTransforms[51].columns.3.y
                        let heightLength = headJointPos - toesJointPos
                        self?.heightLengths.append(Double(heightLength))
                        if let leftShoulderPosition = bodyAnchor.skeleton.modelTransform(for: .leftShoulder)?.columns.3,
                           let rightShoulderPosition = bodyAnchor.skeleton.modelTransform(for: .rightShoulder)?.columns.3 {
                            let shoulderDistance = simd_distance(leftShoulderPosition, rightShoulderPosition)
                            let shoulderDistanceInMeters = Double(shoulderDistance)
                            self?.shoulderLengths.append(shoulderDistanceInMeters)
                        }
                        if let leftHipPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_upLeg_joint"))?.columns.3,
                           let rightHipPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_upLeg_joint"))?.columns.3 {
                            let waistLength = simd_distance(leftHipPosition, rightHipPosition)
                            self?.waistLengths.append(Double(waistLength))
                        }
                        if let leftUpLegPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_upLeg_joint"))?.columns.3,
                           let rightUpLegPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_upLeg_joint"))?.columns.3,
                           let leftFootPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_foot_joint"))?.columns.3,
                           let rightFootPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_foot_joint"))?.columns.3{
                            
                            let leftLegLength = simd_distance(leftUpLegPosition, leftFootPosition)
                            let _ = simd_distance(rightUpLegPosition, rightFootPosition)
                            self?.leftLegLengths.append(Double(leftLegLength))
                        }
                        if let leftHandFingerPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "left_handMid_3_joint"))?.columns.3,
                           let rightHandFingerPosition = skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "right_handMid_3_joint"))?.columns.3 {
                            let armsLength = simd_distance(leftHandFingerPosition, rightHandFingerPosition)
                            self?.armsLengths.append(Double(armsLength))
                        }
                        self?.calculateAndDisplayAverages()
                    }
                }
                
            }
        }
    }
    
    func calculateAndDisplayAverages() {
        
        heightAverage = heightLengths.reduce(0.0, +) / Double(heightLengths.count)
        waistAverage = waistLengths.reduce(0.0, +) / Double(waistLengths.count)
        legAverage = leftLegLengths.reduce(0.0, +) / Double(leftLegLengths.count)
        shoulderAverage = shoulderLengths.reduce(0.0, +) / Double(shoulderLengths.count)
        armsAverage = armsLengths.reduce(0.0, +) / Double(armsLengths.count)
        
        print("Average Measurements:")
        print("Average Height Length: \(heightAverage) meters")
        print("Average Waist Length: \(waistAverage) meters")
        print("Average Left Leg Length: \(legAverage) meters")
        print("Average Shoulder Length: \(shoulderAverage) meters")
        print("Average Arms Length: \(armsAverage) meters")

        storeBodyMeasurementsInFirestore()
    }

    func storeBodyMeasurementsInFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
        
        // Debugging the values of body measurements
        let height = "\(String(format: "%.2f", heightAverage * 100)) cm"
        let waist = "\(String(format: "%.2f", waistAverage * 100)) cm"
        let leg = "\(String(format: "%.2f", legAverage * 100)) cm"
        let shoulder = "\(String(format: "%.2f", shoulderAverage * 100)) cm"
        let arms = "\(String(format: "%.2f", armsAverage * 100)) cm"

        print("Storing body measurements for userID: \(userId)")
        print("Height: \(height), Waist: \(waist), Leg: \(leg), Shoulder: \(shoulder), Arms: \(arms)")
        
        let measurements: [String: Any] = [
            "userId": userId ,
            "average_height": height,
            "average_waist": waist,
            "average_left_leg": leg,
            "average_shoulder": shoulder,
            "average_arms": arms
        ]

        let measurementsRef = firestore.collection("Body Measurements").document(userId)

        print("Uploading data to Firestore...")
        
        measurementsRef.setData(measurements) { error in
            if let error {
                // Log the error with additional details
                print("Error storing body measurements in Firestore: \(error.localizedDescription)")
            } else {
                // Log the success
                print("Successfully stored body measurements in Firestore.")
                self.successMessage()
            }
        }
    }
    
    @objc func successMessage() {
        
        let alert = UIAlertController(title: "Success!", message: "Measurements successfully stored", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let resultVC = UIHostingController(rootView: ResultsView(result: Results(height: self.heightAverage, waist: self.waistAverage, leg: self.legAverage, shoulder: self.shoulderAverage, arms: self.armsAverage)))
            self.navigationController?.pushViewController(resultVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Add manually?", style: .default, handler: { _ in
            let ManualVC = UIHostingController(rootView: ManualMeasurementView())
            
            if let sheet = ManualVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.preferredCornerRadius = 12
                sheet.prefersGrabberVisible = false
            }
            self.present(ManualVC, animated: true)
        }))

        self.present(alert, animated: true)
    }
}
