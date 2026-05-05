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
        ScrollViewReader {proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Date().getCurrentWeek(), id: \.self) {date in
                        
                        WeekDayView(date: date, isToday: date.isToday, completionPercentage: completionPercentage(for: date))
                            .id(date)
                    }
                }
                .padding(16)
            }
            .onAppear {
                if let today = Date().getCurrentWeek().first(where: {$0.isToday }) {
                    withAnimation {
                        proxy.scrollTo(today, anchor: .center)
                    }
                }
            }
        }
    }
}


