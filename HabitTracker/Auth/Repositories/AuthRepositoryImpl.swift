//
//  AuthRepository.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Observation
import FirebaseAuth

@Observable
class AuthRepositoryImpl: AuthRepository {
    func register(email: String, password: String) async throws -> FirebaseAuth.AuthDataResult {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
    }
    
    func isUserSignedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func getUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    
}


