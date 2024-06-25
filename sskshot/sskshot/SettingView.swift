//
//  SettingView.swift
//  sskshot
//
//  Created by kimsangwoo on 4/15/24.
//

import SwiftUI

struct SettingView: View {
    @Binding var isShowingSetting: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Setting")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color.white)
                    .padding(.leading, 4)
                
                Spacer()
                
                Button(action: {
                    isShowingSetting.toggle()
                    HapticManager.instance.impact(style: .medium)
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(Color.secondary)
                        .background(
                            Rectangle()
                                .frame(width: 44, height: 44)
                                .foregroundStyle(Color.clear)
                        )
                })
            } // HStack
            .padding(.all, 20)
            
            Spacer()
        } // VStack
        .background(Color.black)
    }
}
