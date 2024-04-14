//
//  CameraView.swift
//  sskshot
//
//  Created by kimsangwoo on 4/15/24.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var isRecording: Bool
    var didCaptureVideo: (URL) -> Void

    class Coordinator: NSObject, AVCaptureFileOutputRecordingDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
            // Recording started
        }

        func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
            if let error = error {
                print("Error finishing recording: \(error.localizedDescription)")
            } else {
                parent.didCaptureVideo(outputFileURL)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()

        DispatchQueue.global(qos: .background).async {
            let captureSession = AVCaptureSession()

            guard let device = AVCaptureDevice.default(for: .video) else { return }

            do {
                let input = try AVCaptureDeviceInput(device: device)
                captureSession.addInput(input)

                let output = AVCaptureMovieFileOutput()
                captureSession.addOutput(output)

                captureSession.startRunning()

                DispatchQueue.main.async {
                    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer.frame = viewController.view.layer.bounds
                    previewLayer.videoGravity = .resizeAspectFill
                    viewController.view.layer.addSublayer(previewLayer)

                    let connection = output.connection(with: .video)
                    if connection?.isVideoStabilizationSupported ?? false {
                        connection?.preferredVideoStabilizationMode = .auto
                    }

                    let button = Button(action: {
                        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
                        output.startRecording(to: fileURL, recordingDelegate: context.coordinator)
                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.clear)
                    }

                    let hostingController = UIHostingController(rootView: button)
                    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                    viewController.addChild(hostingController)
                    viewController.view.addSubview(hostingController.view)
                    hostingController.didMove(toParent: viewController)
                }
            } catch {
                print("Error setting up camera: \(error.localizedDescription)")
            }
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update UI
    }
}
