//
//  UserRepository.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation

protocol UserRepository {
   
    func saveUserToDatabase(username: String, email: String) async throws
}
