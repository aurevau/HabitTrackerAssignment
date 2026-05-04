//
//  WeekViewExtensions.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-04.
//

import Foundation


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
