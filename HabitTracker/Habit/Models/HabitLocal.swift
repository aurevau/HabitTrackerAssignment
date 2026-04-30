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
    var completedDates: [Date] = []
    var locations: [Location] = []
    
    init(name: String) {
        self.name = name
    }
    
    
}
