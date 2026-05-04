//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import Foundation
import Observation
import CoreLocation
import UIKit

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
            habits[index].locations.removeAll {
                        calendar.isDateInToday($0.date)
            }
            habits[index].images.removeAll {
                calendar.isDateInToday($0.date)
            }
            
        } else {
            habits[index].completedDates.append(Date())
            
            if let location = try? await CLLocationUpdate.currentLocation() {
                let newLocation = Location(name: habit.name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, date: Date()
                )
                habits[index].locations.append(newLocation)
            }
        }
                
        await updateHabit(userId: userId, habit: habits[index], habitImage: nil)

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
    
    func updateHabit(userId: String, habit: Habit, habitImage: UIImage?) async {
        errorMessage = ""
        do {
            try await repository.updateHabit(userId: userId, habit: habit, habitImage: habitImage)
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
    func addImageToHabit(userId: String, habit: Habit, image: UIImage) async {
        guard let index = habits.firstIndex(where: {$0.id == habit.id}) else {return}
        
        await updateHabit(userId: userId, habit: habits[index], habitImage: image)
        
        await loadHabits(userId: userId)
    }
    
    
    func migrateLocalHabits(localHabits: [HabitLocal], userId: String) async  {
        errorMessage = ""
  
        do {
            try await repository.migrateLocalHabits(localHabits: localHabits, userId: userId)
            
            await loadHabits(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
}
