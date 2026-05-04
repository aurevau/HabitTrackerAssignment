//
//  WeekViewExtensions.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-04.
//

import Foundation
import SwiftUI


extension LocalWeekView {
    func completionPercentage(for date: Date) -> Double {
        guard !habits.isEmpty else { return 0.0 }
        
        let completedCount = habits.filter { habit in
            habit.completedDates.contains { completedDate in
                Calendar.current.isDate(completedDate, inSameDayAs: date)
            }
        }.count
        
        return Double(completedCount) / Double(habits.count)
    }
}

extension WeekView {
    func completionPercentage(for date: Date) -> Double {
        guard !habits.isEmpty else { return 0.0 }
        
        let completedCount = habits.filter { habit in
            habit.completedDates.contains { completedDate in
                Calendar.current.isDate(completedDate, inSameDayAs: date)
            }
        }.count
        
        return Double(completedCount) / Double(habits.count)
    }
}


extension WeekDayView {
    var backgroundGradient: LinearGradient {
        if isToday && completionPercentage == 0 {
            return LinearGradient(
                colors: [Color.red.opacity(0.8), Color.red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else if completionPercentage > 0 {
            let colors: [Color]
            
            if completionPercentage <= 0.33 {
                colors = [Color.red.opacity(0.6), Color.orange.opacity(0.8)]
            } else if completionPercentage <= 0.66 {
                colors = [Color.orange.opacity(0.7), Color.yellow.opacity(0.9)]
            } else {
                colors = [Color.yellow.opacity(0.8), Color.green.opacity(1.0)]
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
    
    var textColor: Color {
        (completionPercentage > 0 || isToday) ? .white : .black
    }
}
