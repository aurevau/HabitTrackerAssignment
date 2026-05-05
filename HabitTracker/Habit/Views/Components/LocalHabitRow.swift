//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct LocalHabitRow: View {
    
    @Environment(HabitLocalViewModel.self) private var habitLocalViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    
    let habit: HabitLocal
    var body: some View {
        HStack {
            
            Button {
                habitLocalViewModel.toggleToday(for: habit)
            
            } label: {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(habit.isCompletedToday ? .green : .primaryText)
            }
          
          
            
            VStack(alignment: .leading){
                Text(habit.name)
                    .fontWeight(.semibold)
                  
                Text(habit.habitDescription)
                    .font(.caption)
    
            }
            .foregroundColor(.primaryText)
            
            Spacer()
            
            Text("🔥 \(habit.currentStreak)")
                .font(.subheadline)
                .foregroundColor(.primaryText)
        }
        .padding()
        .gradientCard(isCompleted: habit.isCompletedToday)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .animation(.spring(response: 0.3), value: habit.isCompletedToday)
        .animation(.spring(response: 0.3), value: habit.isCompletedToday)
        
    }
}


