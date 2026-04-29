//
//  UserExtension.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-29.
//

import Foundation

extension User {
    var joinedDate: Date{
        Date(timeIntervalSince1970: joined)
    }
    
    var formattedJoinedDate: String {
        let date = Date(timeIntervalSince1970: joined)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "sv_SE")
        return formatter.string(from: date)
    }
}
