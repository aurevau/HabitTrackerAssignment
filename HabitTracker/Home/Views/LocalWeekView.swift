//
//  WeekView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-29.
//

import SwiftUI

struct LocalWeekView: View {
    let habits: [HabitLocal]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Date().getCurrentWEek(), id: \.self) {date in
                    
                    WeekDayView(date: date, isToday: date.isToday, completionPercentage: completionPercentage(for: date))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    private func completionPercentage(for date: Date) -> Double {
        guard !habits.isEmpty else { return 0.0 }

        let completedCount = habits.filter { habit in
            habit.completedDates.contains { completedDate in
                Calendar.current.isDate(completedDate, inSameDayAs: date)

            }
        }.count
        
        return Double(completedCount) / Double(habits.count)
    }
}


