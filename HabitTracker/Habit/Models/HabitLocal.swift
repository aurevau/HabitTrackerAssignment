//
//  HabitLocal.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-29.
//

import Foundation
import SwiftData

@Model
class HabitLocal {
    var id: UUID = UUID()
    var name: String
    var habitDescription: String
    var completedDates: [Date] = []
    var locations: [Location] = []
    
    init(name: String, description: String) {
        self.name = name
        self.habitDescription = description
    }
}
