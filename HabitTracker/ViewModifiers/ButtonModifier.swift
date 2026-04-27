//
//  ButtonModifier.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation
import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.primaryText)
            .frame(width: 352, height: 50)
            .background(LinearGradient(colors: [Color.theme.cardGradientStart, Color.theme.cardGradientMid, Color.theme.cardGradientEnd], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(12)
    }
}


struct ButtonModifierReversedColors: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.primaryText)
            .frame(width: 352, height: 50)
            .background(LinearGradient(colors: [Color.theme.cardGradientEnd, Color.theme.cardGradientMid, Color.theme.cardGradientStart], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(12)
    }
}

struct OutlineButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(Color.theme.primaryText)
            .frame(width: 352, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.theme.cardGradientStart,
                                Color.theme.cardGradientEnd
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2
                    )
            )
    }
}
