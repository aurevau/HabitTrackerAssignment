//
//  UserRepositoryImpl.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UIKit

class UserRepositoryImpl {
    func getUserDetails(userId: String) async throws -> User {
        let snapshot = try await db.collection("users")
            .document(userId)
            .getDocument()
        
        return try snapshot.data(as: User.self)
    }
    
    
    
    private var db = Firestore.firestore()
    func saveUserToDatabase(username: String, email: String, profileImage: UIImage? = nil) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var imageUrl: String? = nil
        if let image = profileImage {
            imageUrl = try await uploadProfileImage(image: image, userId: uid)
        }
        
        let newUser = User(id: uid, username: username, email: email, joined: Date().timeIntervalSince1970, profileImageUrl: imageUrl)
        
        try db.collection("users")
            .document(uid)
            .setData(from: newUser)
    }
    
    func uploadProfileImage(image: UIImage, userId: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badServerResponse)
        }
        
        let ref = Storage.storage().reference().child("profile_images/\(userId)")
        
        let result = try await ref.putDataAsync(imageData)
        
        let url = try await ref.downloadURL()
        
        return url.absoluteString
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
