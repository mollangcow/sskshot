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
        VStack(spacing: 0) {
            // top navi bar
            HStack {
                // flash button
                Button {
                    isFlash.toggle()
                    HapticManager.instance.impact(style: .medium)
                } label: {
                    Circle()
                        .foregroundStyle(Color.secondary.opacity(0.8))
                        .overlay {
                            Image(systemName: isFlash ? "bolt.fill" : "bolt.slash.fill")
                                .foregroundColor(isFlash ? .yellow : .white)
                        }
                        .frame(width: 44, height: 44)
                } // button
                .contentTransition(.symbolEffect(.replace))
                
                Spacer()
                
                // setting button
                Button {
                    isShowingSetting.toggle()
                    HapticManager.instance.impact(style: .medium)
                } label: {
                    Circle()
                        .foregroundStyle(Color.secondary.opacity(0.8))
                        .overlay {
                            Image(systemName: "gear")
                                .foregroundStyle(Color.white)
                        }
                        .frame(width: 44, height: 44)
                } // button
                .sheet(isPresented: $isShowingSetting) {
                    SettingView(isShowingSetting: $isShowingSetting)
                        .presentationDetents([.medium])
                } //sheet
            } //HStack
            .padding(.horizontal, 20)
            
            Spacer()
            
            // video indicator
            Text("0:00:00.00")
                .padding(.all, 8)
                .background(Color.secondary.opacity(0.8))
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
                .foregroundStyle(Color.white)
                .monospaced()
            
            // bottom tool bar
            HStack {
                // gallery button
                Button {
                    isShowingGallery.toggle()
                    HapticManager.instance.impact(style: .medium)
                } label: {
                    Circle()
                        .foregroundStyle(Color.secondary.opacity(0.8))
                        .overlay{
                            Image(systemName: "photo.stack.fill")
                                .foregroundStyle(Color.white)
                        }
                        .frame(width: 62, height: 62)
                } // button
                .sheet(isPresented: $isShowingGallery) {
                    GalleryView(isShowingGallery: $isShowingGallery)
                } // sheet
                
                Spacer()
                
                // recording button
                Button {
                    withAnimation(.bouncy(duration: 0.3)) {
                        isRecording.toggle()
                    }
                    HapticManager.instance.notification(type: .success)
                } label: {
                    Circle()
                        .foregroundStyle(Color.red.opacity(0.3))
                        .overlay {
                            AnimationRectangle(cornerRadius: isRecording ? 4 : 37)
                                .foregroundStyle(Color.red)
                                .frame(
                                    width: isRecording ? 30 : 74,
                                    height: isRecording ? 30: 74
                                )
                        }
                        .frame(width: 74, height: 74)
                } // button
                
                Spacer()
                
                // capture button
                Button {
                    HapticManager.instance.notification(type: .success)
                } label: {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 62, height: 62)
                } // button
            } // HStack
            .padding(.all, 32)
        }
        .background(Color.black)
    }
}
