//
//  VideoUploader.swift
//  Physiotherapy
//
//  Created by admin@33 on 13/12/24.
//

import Foundation
import Alamofire

class VideoUploader {
    static func uploadVideo(videoURL: URL, completion: @escaping (Bool, String?) -> Void) {
        let endpoint = "https://ttl-18h-25jan-4264hmak2a-em.a.run.app/output_video"
        
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        
        // Start uploading the video
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(videoURL, withName: "file", fileName: "video.mp4", mimeType: "video/mp4")
        }, to: endpoint, headers: headers)
        .uploadProgress { progress in
            // Track and print upload progress
            print("Upload Progress: \(progress.fractionCompleted * 100)%")
        }
        .response { response in
            // Handle the server response
            switch response.result {
            case .success(let data):
                if let data = data {
                    // Parse JSON response
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Parsed JSON Response: \(responseJSON)")
                        
                        // Check for URL in the response, indicating successful upload
                        if let responseDict = responseJSON as? [String: Any],
                           let videoURL = responseDict["URL"] as? String, !videoURL.isEmpty {
                            // Handle successful upload with video URL
                            completion(true, "Upload successful! Video URL: \(videoURL)")
                        } else {
                            // Handle failed upload if URL is not found
                            completion(false, "Upload failed or server returned unexpected response: \(responseJSON)")
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                        completion(false, "Error parsing JSON: \(error.localizedDescription)")
                    }
                } else {
                    print("Success but no data returned")
                    completion(false, "Success but no data returned")
                }
            case .failure(let error):
                // Handle error in case the request failed
                print("Upload failed with error: \(error)")
                completion(false, "Upload failed with error: \(error.localizedDescription)")
            }
        }
    }
}

