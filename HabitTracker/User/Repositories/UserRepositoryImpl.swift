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
    
    
    private var db = Firestore.firestore()
    func saveUserToDatabase(username: String, email: String) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let newUser = User(id: uid, username: username, email: email, joined: Date().timeIntervalSince1970)
        
        try await db.collection("users")
            .document(uid)
            .setData(from: newUser)
    }
    
    


   
    
    

    
    
    
   
}
