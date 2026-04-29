//
//  WeekView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-29.
//

import SwiftUI

struct WeekView: View {
    let habits: [Habit]
    
    var body: some View {
        ScrollViewReader {proxy in
            
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Date().getCurrentWEek(), id: \.self) {date in
                        
                        WeekDayView(date: date, isToday: date.isToday, completionPercentage: completionPercentage(for: date))
                            .id(date)
                    }
                }
                .padding(16)
                
            }
            .onAppear {
                if let today = Date().getCurrentWEek().first(where: {$0.isToday }) {
                    withAnimation {
                        proxy.scrollTo(today, anchor: .center)
                    }
                }
            }
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


