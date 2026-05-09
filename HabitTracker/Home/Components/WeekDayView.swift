//
//  WeekDayView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-29.
//

import SwiftUI

struct WeekDayView: View {
    @Environment(HabitLocalViewModel.self) private var habitLocalViewModel
    @Environment(HabitViewModel.self) private var habitViewModel
    
    let date: Date
    let isToday: Bool
    let completionPercentage: Double
    
    var body: some View {
        VStack(spacing: 4) {
            Text(date.dayNumber)
                .font(.subheadline)
                .fontWeight(.bold)
            
            Text(date.dayName)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(width: 65, height: 75)
        .background(RoundedRectangle(cornerRadius: 20)
            .fill(backgroundGradient)
        )
        .foregroundColor(textColor)
        
    }
}


