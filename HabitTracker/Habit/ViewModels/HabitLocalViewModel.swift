//
//  HabitLocalViewModel.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-29.
//

import Foundation
import Observation
import SwiftData
import CoreLocation

@Observable
class HabitLocalViewModel {
    var modelContext: ModelContext? = nil
    var modelContainer: ModelContainer? = nil
    
    var habits: [HabitLocal] = []
    
    
    var errorMessage = ""
    
    @MainActor
    init(inMemory: Bool) {
    
        do {
            
            let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
            let container = try ModelContainer(for: HabitLocal.self, configurations: configuration)
            modelContainer = container
            
           
            modelContext = container.mainContext
            modelContext?.autosaveEnabled = true
            
            queryHabits()
            
            
        } catch  {
            errorMessage = error.localizedDescription
        }
    }
    
    func queryHabits() {
        guard let modelContext = modelContext else {
            self.errorMessage = "Ingen databas kopplad"
            return
        }
        
        var descriptor = FetchDescriptor<HabitLocal>(
            predicate: nil,
            sortBy: [.init(\.name)]
        )
        descriptor.fetchLimit = 100
        
        do {
            habits = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func saveHabit(name: String) {
        guard let modelContext = modelContext else { return }
            
            let habit = HabitLocal(name: name)
            modelContext.insert(habit)
            
            do {
                try modelContext.save()
                queryHabits()
            } catch {
                errorMessage = error.localizedDescription
            }
        
    }
    
    func toggleToday(for habit: HabitLocal) {
            let calendar = Calendar.current
            
            if let todayIndex = habit.completedDates.firstIndex(where: {
                calendar.isDateInToday($0)
            }) {
                habit.completedDates.remove(at: todayIndex)
                habit.locations.removeAll {
                    calendar.isDateInToday($0.date)
                }
                
                save()
                
            } else {
                habit.completedDates.append(Date())
                
                Task {
                    if let location = try? await CLLocationUpdate.currentLocation() {
                        let newLocation = Location(name: habit.name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, date: Date())
                        
                        habit.locations.append(newLocation)
                    }
                    save()
                }
            }
            
        }
    
    private func save() {
        do {
            try modelContext?.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteHabit(_ habit: HabitLocal) {
        guard let modelContext = modelContext else {return}
        
        modelContext.delete(habit)
        
        do {
            try modelContext.save()
            queryHabits()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
