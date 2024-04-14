//
//  Path+.swift
//  sskshot
//
//  Created by kimsangwoo on 4/15/24.
//

import SwiftUI

struct AnimationRectangle: Shape {
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        get { cornerRadius }
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            _ = rect.width / 2
            _ = rect.height / 2
            let topLeftCenter = CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius)
            let topRightCenter = CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius)
            let bottomLeftCenter = CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius)
            let bottomRightCenter = CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius)
            
            path.move(to: CGPoint(x: rect.minX, y: topLeftCenter.y))
            path.addArc(center: topLeftCenter, radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            
            path.addLine(to: CGPoint(x: topRightCenter.x, y: rect.minY))
            path.addArc(center: topRightCenter, radius: cornerRadius, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 0), clockwise: false)
            
            path.addLine(to: CGPoint(x: rect.maxX, y: bottomRightCenter.y))
            path.addArc(center: bottomRightCenter, radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            
            path.addLine(to: CGPoint(x: bottomLeftCenter.x, y: rect.maxY))
            path.addArc(center: bottomLeftCenter, radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        }
    }
}
