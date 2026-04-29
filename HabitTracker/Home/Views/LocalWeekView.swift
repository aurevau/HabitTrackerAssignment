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
                    
                    WeekDayView(date: date, isToday: date.isToday, isCompleted: isDateCompleted(date))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    private func isDateCompleted(_ date: Date) -> Bool {
        habits.contains {habit in
            habit.completedDates.contains {completedDate in
                Calendar.current.isDate(completedDate, inSameDayAs: date)
            }
        }
    }
}


