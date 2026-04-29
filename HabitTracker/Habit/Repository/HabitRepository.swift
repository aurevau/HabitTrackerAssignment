//
//  HabitRepository.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import Foundation
import FirebaseFirestore

class HabitRepository {
    private let db = Firestore.firestore()
    
    func saveHabit(userId: String, habit: Habit) async throws {
        let data: [String: Any] = [
            "id": habit.id,
            "name": habit.name,
            "completedDates": habit.completedDates.map {$0.timeIntervalSince1970}
        ]
        
        try await db.collection("users")
            .document(userId)
            .collection("habits")
            .document(habit.id)
            .setData(data)
        
    }
    
    func updateHabit(userId: String, habit: Habit) async throws {
        let data: [String: Any] = [
            "id": habit.id,
            "name": habit.name,
            "completedDates": habit.completedDates.map {$0.timeIntervalSince1970}
        ]
        
        try await db.collection("users")
            .document(userId)
            .collection("habits")
            .document(habit.id)
            .setData(data, merge: true)
        
    }
    
    
    
    func fetchHabits(userId: String) async throws -> [Habit] {
        let snapshot = try await db.collection("users").document(userId).collection("habits").getDocuments()
        
        return snapshot.documents.compactMap {doc in
            let data = doc.data()
            
            guard let id = data["id"] as? String,
                  let name = data["name"] as? String else {
                return nil
            }
            
            let timestamps = data["completedDates"] as? [TimeInterval] ?? []
            let dates = timestamps.map {Date(timeIntervalSince1970: $0)}
            
            return Habit(id: id, name: name, completedDates: dates)
        }
    }
    
    
    func deleteHabit(userId: String, habitId: String) async throws {
        try await db.collection("users")
            .document(userId)
            .collection("habits")
            .document(habitId)
            .delete()
    }
    
    
}
