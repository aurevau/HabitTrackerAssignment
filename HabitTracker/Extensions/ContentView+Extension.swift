//
//  ContentView+Extension.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-05.
//

import Foundation

extension ContentView {
    
     func migrateHabitsToFirebase(habitLocalViewModel: HabitLocalViewModel, userId: String, habitViewModel: HabitViewModel) async {
        let localHabits = habitLocalViewModel.habits
        
        guard !localHabits.isEmpty else {
            return
        }
        
        await habitViewModel.migrateLocalHabits(localHabits: localHabits, userId: userId)
        
        if habitViewModel.errorMessage == nil {
            for habit in localHabits {
                habitLocalViewModel.deleteHabit(habit)
            }
        } else {
            //Migration Failed
        }
    }
}
