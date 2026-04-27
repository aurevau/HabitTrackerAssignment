//
//  User.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation



struct User: Identifiable {
    let id = UUID()
    var name: String
    var email: String
    let joined: TimeInterval
}
