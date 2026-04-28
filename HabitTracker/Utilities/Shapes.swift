//
//  Shapes.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct Arc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX - 1, y: rect.minY))
        
        path.addQuadCurve(to: CGPoint(x: rect.maxX + 1, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.midY))
        
        path.addLine(to: CGPoint(x: rect.maxX + 1, y: rect.maxY + 1))
        path.addLine(to: CGPoint(x: rect.minX - 1, y: rect.maxY + 1))
        path.closeSubpath()
        
        return path
    }
}



struct HeadTabShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0.42105*width, y: 0))
        path.addLine(to: CGPoint(x: 0.57895*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.77343*width, y: 0.48699*height),
                      control1: CGPoint(x: 0.69925*width, y: 0),
                      control2: CGPoint(x: 0.73497*width, y: 0.2414*height))
        path.addCurve(to: CGPoint(x: 0.98496*width, y: height),
                      control1: CGPoint(x: 0.81325*width, y: 0.74125*height),
                      control2: CGPoint(x: 0.85338*width, y: height))
        path.addLine(to: CGPoint(x: 0.01504*width, y: height))
        path.addCurve(to: CGPoint(x: 0.22657*width, y: 0.48699*height),
                      control1: CGPoint(x: 0.14662*width, y: height),
                      control2: CGPoint(x: 0.18675*width, y: 0.74125*height))
        path.addCurve(to: CGPoint(x: 0.42105*width, y: 0),
                      control1: CGPoint(x: 0.26503*width, y: 0.2414*height),
                      control2: CGPoint(x: 0.30075*width, y: 0))
        path.closeSubpath()
        
        return path
    }
}
