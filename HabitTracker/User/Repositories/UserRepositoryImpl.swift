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
    private var db = Firestore.firestore()
    
    func getUserDetails(userId: String) async throws -> User {
        guard !userId.isEmpty else {
            throw NSError(domain: "InvalidUserId", code: 0)
        }
        let snapshot = try await db.collection("users")
            .document(userId)
            .getDocument()
        
        return try snapshot.data(as: User.self)
    }
    
    func saveUserToDatabase(username: String, email: String, profileImage: UIImage? = nil, userId: String) async throws {
        var imageUrl: String? = nil
        if let image = profileImage {
            imageUrl = try await uploadProfileImage(image: image, userId: userId)
        }
        
        let newUser = User(id: userId, username: username, email: email, joined: Date().timeIntervalSince1970, profileImageUrl: imageUrl)
        
        try await db.collection("users")
            .document(userId)
            .setData(from: newUser)
    }
    
    func updateUserToDatabase(profileImage: UIImage? = nil, userId: String) async throws {
        
        if let image = profileImage {
            let imageUrl = try await uploadProfileImage(image: image, userId: userId)
            
            let data: [String: Any] = [
                "profileImageUrl": imageUrl
            ]
            
            try await db.collection("users")
                .document(userId)
                .setData(data, merge: true)
        }
    }
    func uploadProfileImage(image: UIImage, userId: String) async throws -> String {
        let imageData = await Task.detached(priority: .userInitiated) {
            let maxSize: CGFloat = 400
            let scale = min(maxSize / image.size.width, maxSize / image.size.height, 1.0)
            
            if scale < 1.0 {
                let newSize = CGSize(
                    width: image.size.width * scale,
                    height: image.size.height * scale
                )
                
                let renderer = UIGraphicsImageRenderer(size: newSize)
                let resized = renderer.image { _ in
                    image.draw(in: CGRect(origin: .zero, size: newSize))
                }
                return resized.jpegData(compressionQuality: 0.5)
            }
            
            return image.jpegData(compressionQuality: 0.5)
        }.value
        
        guard let imageData = imageData else {
            throw NSError(domain: "ImageError", code: -1)
        }
        
        let ref = Storage.storage().reference().child("profile_images/\(userId).jpg")
        
        _ = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        
        return url.absoluteString
    }
}
