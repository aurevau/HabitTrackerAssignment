//
//  GradientCard.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation
import SwiftUI

struct GradientCard: ViewModifier {
    var isCompleted: Bool = false
    func body(content: Content) -> some View {
        content
            .background(
                isCompleted ? LinearGradient(colors: [Color.green.opacity(0.3), Color.green.opacity(0.5)], startPoint: .leading, endPoint: .trailing) :
            LinearGradient(colors: [Color.theme.cardGradientEnd, Color.theme.cardGradientStart], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


extension View {
    func gradientCard(isCompleted: Bool = false) -> some View {
        self.modifier(GradientCard(isCompleted: isCompleted))
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

}
