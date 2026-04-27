//
//  GradientCard.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation
import SwiftUI

struct GradientCard: ViewModifier {
    func body(content: Content) -> some View {
        
        ZStack {
            LinearGradient(colors: [Color.theme.cardGradientEnd, Color.theme.cardGradientStart], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            content
        }
    }
}


extension View {
    func gradientCard() -> some View {
        self.modifier(GradientCard())
    }
}

extension Shape {
    func gradientCard() -> some View
    {
        self.fill (
            LinearGradient(
                            colors: [
                                Color.theme.cardGradientStart,
                                Color.theme.cardGradientMid,
                                Color.theme.cardGradientEnd
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
        )
    }
    
    func darkCard() -> some View {
        self.fill(Color.theme.cardBackground)
    }
}
