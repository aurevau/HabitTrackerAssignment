//
//  DateExtensions.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-29.
//

import Foundation

extension Date {
    
    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "sv_SE")
        return formatter.string(from: self).capitalized
    }
    
    func getCurrentWEek() -> [Date] {
        let calendar = Calendar.current
        var calendar_sv = calendar
        calendar_sv.firstWeekday = 2
        calendar_sv.locale = Locale(identifier: "sv_SE")
        
        guard let weekInterval = calendar_sv.dateInterval(of: .weekOfYear, for: self) else {
            return []
        }
        
        var dates: [Date] = []
        var currentDate = weekInterval.start
        
        for _ in 0..<7 {
            dates.append(currentDate)
            currentDate = calendar_sv.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
