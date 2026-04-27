//
//  GradientBackground.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation
import SwiftUI

struct GradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        
        ZStack {
            LinearGradient(colors: [Color.theme.bgLight, Color.theme.bgDark], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            content
        }
    }
}


extension View {
    func gradientBackground() -> some View {
        self.modifier(GradientBackground())
    }
}
