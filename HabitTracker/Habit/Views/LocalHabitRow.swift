//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct HabitRow: View {
    let habit: Habit
    var body: some View {
        HStack {
            Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(habit.isCompletedToday ? .green : .secondary)
            
            Text(habit.name)
        }
    }
}


