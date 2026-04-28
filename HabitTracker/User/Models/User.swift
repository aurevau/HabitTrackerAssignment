//
//  User.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation



struct User: Identifiable, Codable {
    let id: String
    var username: String
    var email: String
    let joined: TimeInterval
}
