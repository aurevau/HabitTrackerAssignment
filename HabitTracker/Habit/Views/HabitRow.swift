//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct HabitRow: View {
    
    @Environment(HabitViewModel.self) private var habitViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    
    
    let habit: Habit
    var body: some View {
        HStack {
            
            Button {
                Task {
                    await habitViewModel.toggleToday(for: habit, userId: authViewModel.currentUserId)
                }
            } label: {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(habit.isCompletedToday ? .green : .primaryText)
              
            }
        
          
            
            Text(habit.name)
                .fontWeight(.semibold)
                .foregroundColor(.primaryText)
            
            Spacer()
            
            Text("🔥 \(habit.currentStreak)")
                .font(.subheadline)
                .foregroundColor(.primaryText)
        }
        .padding()
        .gradientCard()
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .animation(.spring(response: 0.3), value: habit.isCompletedToday)
        
    }
}


