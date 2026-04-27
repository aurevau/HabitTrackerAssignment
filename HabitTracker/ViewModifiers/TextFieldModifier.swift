//
//  TextFieldModifier.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import SwiftUI


struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(width: 352, height: 50)
            .font(.subheadline)
            .background(Color.theme.bgLight)
            .cornerRadius(10)
            
    }
}
