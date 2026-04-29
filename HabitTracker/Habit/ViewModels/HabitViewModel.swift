//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import Foundation
import Observation

@Observable
class HabitViewModel {
    var habits: [Habit] = []
    
    var errorMessage: String?
    
    private let repository = HabitRepository()
    
    func toggleToday(for habit: Habit, userId: String) async {
        
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }

        
        let calendar = Calendar.current
        
        if let todayIndex = habits[index].completedDates.firstIndex(where: {
            calendar.isDateInToday($0)
        }) {
            habits[index].completedDates.remove(at: todayIndex)
        } else {
            habits[index].completedDates.append(Date())
        }
                
        await updateHabit(userId: userId, habit: habits[index])

    }
    
    func loadHabits(userId: String) async {
        errorMessage = ""
        do {
            habits = try await repository.fetchHabits(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func saveHabit(userId: String, habit: Habit) async {
        errorMessage = ""
        do {
            habits.append(habit)
            try await repository.saveHabit(userId: userId, habit: habit)
        } catch {
            errorMessage = error.localizedDescription
            habits.removeAll { $0.id == habit.id }
        }
    }
    
    func deleteHabit(userId: String, habitId: String) async {
        errorMessage = ""
        
        let habitToRemove = habits.first { $0.id == habitId }
              habits.removeAll { $0.id == habitId }
        do {
            try await repository.deleteHabit(userId: userId, habitId: habitId)
        } catch {
            if let habit = habitToRemove {
                            habits.append(habit)
                        }
            errorMessage = error.localizedDescription
            
        }
    }
    
    func updateHabit(userId: String, habit: Habit) async {
        errorMessage = ""
        do {
            try await repository.updateHabit(userId: userId, habit: habit)
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
}
