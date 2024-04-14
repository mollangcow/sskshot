//
//  ContentView.swift
//  sskshot
//
//  Created by kimsangwoo on 4/15/24.
//

import SwiftUI
import AVKit
import PhotosUI

struct ContentView: View {
    @State private var isRecording: Bool = false
    @State private var isPicturing: Bool = false
    @State private var isFlash: Bool = false
    @State private var isShowingGallery: Bool = false
    @State private var isShowingSetting: Bool = false
    @State private var videoURL: URL?
    @State private var isVideoRecorded = false
    @State private var savedVideoPath: String?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    
    var body: some View {
        ZStack {
            if let videoURL = videoURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 300)
                    .onAppear {
                    }
            } else {
                CameraView(isRecording: $isRecording, didCaptureVideo: { url in
                    videoURL = url
                    isVideoRecorded = false
                })
            }
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        // flash light
                        isFlash.toggle()
                        HapticManager.instance.impact(style: .medium)
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(.black.opacity(0.3))
                                .frame(width: 44, height: 44)
                            Image(systemName: isFlash ? "bolt.fill" : "bolt.slash.fill")
                                .foregroundColor(isFlash ? .yellow : .white)
                        }
                    })

                    Spacer()
                    
                    Text("00:00:00")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .monospaced()
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingSetting.toggle()
                        HapticManager.instance.impact(style: .medium)
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(.black.opacity(0.3))
                                .frame(width: 44, height: 44)
                            Image(systemName: "gear")
                                .foregroundColor(.white)
                        }
                    })
                    .fullScreenCover(isPresented: $isShowingSetting) {
                        SettingView(isShowingSetting: $isShowingSetting)
                    }
                }
                .padding(.all, 20)
                
                Spacer()
                
                HStack {
                    // Gallery Button
                    Button(action: {
                        isShowingGallery.toggle()
                        HapticManager.instance.impact(style: .medium)
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.5))
                                .frame(width: 62, height: 62)
                            Image(systemName: "photo.stack.fill")
                                .foregroundColor(.white)
                        }
                    })
                    .fullScreenCover(isPresented: $isShowingGallery) {
                        GalleryView(isShowingGallery: $isShowingGallery)
                    }
//                    PhotosPicker(selection: $selectedPhoto) {
//                        Image(systemName: "photo.stack.fill")
//                            .foregroundColor(.white)
//                            .background() {
//                                Circle()
//                                    .fill(.white.opacity(0.5))
//                                    .frame(width: 62, height: 62)
//                            }
//                    }
                    
                    Spacer()
                    
                    // Recording Button
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.5))
                            .frame(width: 84, height: 84)
                        Button(action: {
                            // recording logic
                            withAnimation(.bouncy(duration: 0.4)) {
                                isRecording.toggle()
                            }
                            HapticManager.instance.notification(type: .success)
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(.clear)
                                    .frame(width: 72, height: 72)
                                AnimationRectangle(cornerRadius: isRecording ? 4 : 36)
                                    .fill(.red)
                                    .frame(
                                        width: isRecording ? 30 : 72,
                                        height: isRecording ? 30: 72
                                    )
                            }
                        })
                    }
                    
                    Spacer()
                    
                    // Picturing Button
                    Button(action: {
                        // recording logic
                        HapticManager.instance.notification(type: .success)
                    }, label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 62, height: 62)
                    })
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
            .padding(.vertical, 30)
        }
        .ignoresSafeArea()
    }
}
