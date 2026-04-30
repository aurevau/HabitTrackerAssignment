//
//  Location.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-30.
//

import Foundation

struct Location: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    var date: Date
}
