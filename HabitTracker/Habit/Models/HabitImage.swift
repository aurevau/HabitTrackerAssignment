//
//  Image.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-04.
//

import Foundation
struct Image: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var image: String? = nil
    var date: Date
    
}
