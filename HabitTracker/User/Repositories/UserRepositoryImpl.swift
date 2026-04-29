//
//  UserRepositoryImpl.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserRepositoryImpl: UserRepository {
    func getUserDetails(userId: String) async throws -> User {
        let snapshot = try await db.collection("users")
            .document(userId)
            .getDocument()
        
        return try snapshot.data(as: User.self)
    }
    
    
    
    private var db = Firestore.firestore()
    func saveUserToDatabase(username: String, email: String) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let newUser = User(id: uid, username: username, email: email, joined: Date().timeIntervalSince1970)
        
        try db.collection("users")
            .document(uid)
            .setData(from: newUser)
    }
    
    


   
    
    

    
    
    
   
}
