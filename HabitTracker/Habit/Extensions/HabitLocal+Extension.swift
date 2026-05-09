//
//  HabitExtension.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import Foundation

extension HabitLocal {
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return completedDates.contains {date in
            calendar.isDateInToday(date)
        }
    }
    
    func daysBetween(_ first: Date, _ second: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: first)
        let end = calendar.startOfDay(for: second)
        
        let components = calendar.dateComponents([.day], from: start, to: end)
        return components.day ?? 0
    }
    
    var currentStreak: Int {
        let calendar = Calendar.current
        
        let uniqueDays = Set(completedDates.map {
            calendar.startOfDay(for: $0)})
        let sortedDays = uniqueDays.sorted(by: >)
        
        guard let latest = sortedDays.first else {
            return 0
        }
        let today = calendar.startOfDay(for: Date())
        
        let daysSinceLatest = calendar.dateComponents([.day], from: latest, to: today).day ?? 0
        
        if daysSinceLatest > 1 {
            return 0
        }
        
        var streak = 1
        var expected = calendar.date(byAdding: .day, value: -1, to: latest)!
        
        for day in sortedDays.dropFirst() {
            if day == expected {
                streak += 1
                expected = calendar.date(byAdding: .day, value: -1,  to: expected)!
            } else {
                break
            }
        }
        return streak 
        
    }
}

