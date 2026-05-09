//
//  AuthRepository.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation
import FirebaseAuth

protocol AuthRepository {
    func register(email: String, password: String, username: String) async throws -> AuthDataResult
    
    func login(email: String, password: String) async throws 
    
    func logOut() throws
    
    func isUserSignedIn() -> Bool
    
    func getUserId () -> String?
    
    
}
