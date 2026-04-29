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
    
    private var backgroundGradient: LinearGradient {
        if isToday && completionPercentage == 0 {
            return LinearGradient(
                colors: [Color.red.opacity(0.8), Color.red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else if completionPercentage > 0 {
            let colors: [Color]
            
            if completionPercentage <= 0.33 {
                colors = [
                    Color.red.opacity(0.6),
                    Color.orange.opacity(0.8)
                ]
            } else if completionPercentage <= 0.66 {
                colors = [
                    Color.orange.opacity(0.7),
                    Color.yellow.opacity(0.9)
                ]
            } else {
                colors = [
                    Color.yellow.opacity(0.8),
                    Color.green.opacity(1.0)
                ]
            }
            
            return LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var textColor: Color {
        (completionPercentage > 0 || isToday) ? .white : .black
    }
}


