//
//  Habit.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var completedDates: [Date] = []
    var locations: [Location] = []
    var images: [HabitImage] = []
}
