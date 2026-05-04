//
//  Image.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-04.
//

import Foundation
struct HabitImage: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var habitImage: String? = nil
    var date: Date
    
}
