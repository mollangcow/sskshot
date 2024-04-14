//
//  VideoCaptureView.swift
//  sskshot
//
//  Created by kimsangwoo on 4/15/24.
//

import SwiftUI
import AVKit
import Photos

struct VideoCaptureView: View {
    @State private var isRecording = false
    @State private var videoURL: URL?
    @State private var isVideoRecorded = false
    @State private var savedVideoPath: String?

    var body: some View {
        VStack {
            if let videoURL = videoURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 300)
                    .onAppear {
                        if !isVideoRecorded {
                            saveVideo(to: videoURL)
                        }
                    }
            } else {
                CameraView(isRecording: $isRecording, didCaptureVideo: { url in
                    videoURL = url
                    isVideoRecorded = false
                })
            }

            HStack {
                Button(action: {
                    isRecording.toggle()
                }) {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                        .background(isRecording ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if let videoURL = videoURL, !isVideoRecorded {
                    Button(action: {
                        saveVideo(to: videoURL)
                    }) {
                        Text("Save Video")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }

            if let savedVideoPath = savedVideoPath {
                Text("Video saved at: \(savedVideoPath)")
                    .padding()
            }
        }
    }

    private func saveVideo(to url: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("Permission denied. Please enable access to the photo library.")
                return
            }

            PHPhotoLibrary.shared().performChanges {
                let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                let placeholder = request?.placeholderForCreatedAsset
                savedVideoPath = placeholder?.localIdentifier
            } completionHandler: { success, error in
                if success {
                    print("Video saved to photo gallery")
                } else {
                    if let error = error {
                        print("Error saving video: \(error.localizedDescription)")
                    }
                }
                isVideoRecorded = true
            }
        }
    }
}
