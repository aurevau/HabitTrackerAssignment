//
//  HabitRepository.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class HabitRepository {
    private let db = Firestore.firestore()
    
    func saveHabit(userId: String, habit: Habit) async throws {
        let data: [String: Any] = [
            "id": habit.id,
            "name": habit.name,
            "description": habit.description,
            "completedDates": habit.completedDates.map {$0.timeIntervalSince1970}
        ]
        
        try await db.collection("users")
            .document(userId)
            .collection("habits")
            .document(habit.id)
            .setData(data)
        
    }
    
    func updateHabit(userId: String, habit: Habit, habitImage: UIImage? = nil) async throws {
        
        var updatedHabit = habit
        
        if let image = habitImage {
            let imageUrl = try await uploadHabitPicture(image: image, userId: userId, habitId: habit.id)
            let locationId = habit.locations.first {
                Calendar.current.isDateInToday($0.date)
            }?.id
            let newImage = HabitImage(locationId: locationId, habitImage: imageUrl)
            updatedHabit.images.append(newImage)
        }
        
        let data: [String: Any] = [
            "id": habit.id,
            "name": habit.name,
            "description": habit.description,
            "completedDates": habit.completedDates.map {$0.timeIntervalSince1970},
            "locations": updatedHabit.locations.map {
                [
                    "id": $0.id.uuidString,
                    "name" : $0.name,
                    "latitude": $0.latitude,
                    "longitude": $0.longitude,
                    "date": $0.date.timeIntervalSince1970
                ]
            },
            "images": updatedHabit.images.map {
                [
                    "id": $0.id.uuidString,
                    "habitImage": $0.habitImage ?? "",
                    "locationId": $0.locationId?.uuidString ?? ""
                ]
            }
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
                  let description = data["description"] as? String,
                  let name = data["name"] as? String else {
                return nil
            }
            
            let timestamps = data["completedDates"] as? [TimeInterval] ?? []
            let dates = timestamps.map {Date(timeIntervalSince1970: $0)}
            
            let locationData = data["locations"] as? [[String: Any]] ?? []
            let locations = locationData.compactMap {location -> Location? in
                
                guard let idString = location["id"] as? String,
                      let name = location["name"] as? String,
                      let latitude = location["latitude"] as? Double,
                      let longitude = location["longitude"] as? Double,
                      let dateInterval = location["date"] as? TimeInterval else {
                    return nil
                }
                
                return Location(id: UUID(uuidString: idString) ?? UUID(), name: name, latitude: latitude, longitude: longitude, date: Date(timeIntervalSince1970: dateInterval))
            }
            
            let imageData = data["images"] as? [[String: Any]] ?? []
            let images: [HabitImage] = imageData.compactMap {image in
                guard let idString = image["id"] as? String else { return nil }
                
                let locationId = (image["locationId"] as? String).flatMap { UUID(uuidString: $0) }
                
                return HabitImage(
                    id: UUID(uuidString: idString) ?? UUID(),
                    locationId: UUID(uuidString: image["locationId"] as? String ?? ""),
                    habitImage: image["habitImage"] as? String
                )
            }
            return Habit(id: id, name: name, description: description, completedDates: dates, locations: locations,  images: images)
        }
    }
    
    
    func deleteHabit(userId: String, habitId: String) async throws {
        try await db.collection("users")
            .document(userId)
            .collection("habits")
            .document(habitId)
            .delete()
    }
    
    func migrateLocalHabits(localHabits: [HabitLocal], userId: String) async throws {
        for localHabit in localHabits {
            let firebaseHabit = Habit(id: UUID().uuidString, name: localHabit.name, description: localHabit.habitDescription, completedDates: localHabit.completedDates)
            
            try await saveHabit(userId: userId, habit: firebaseHabit)
        }
    }
    
    func uploadHabitPicture(image: UIImage, userId: String, habitId: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badServerResponse)
        }
        let filename = UUID().uuidString
        let ref = Storage.storage().reference()
            .child("habit_images/\(userId)/\(habitId)/\(filename).jpg")
        
        let result = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        
        return url.absoluteString
    }
    
    
}
