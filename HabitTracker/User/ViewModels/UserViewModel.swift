//
//  UserViewModel.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation
import Observation
import UIKit

@Observable
class UserViewModel {
    
    private var userRepo = UserRepositoryImpl()
    
    var errorMessage = ""
    
    var currentUser: User?
    
    func getUserDetails(userId: String) async  {
        errorMessage = ""
        do {
            currentUser = try await userRepo.getUserDetails(userId: userId)
            
        } catch {
            errorMessage = error.localizedDescription
            
        }
    }
    
    func saveUserToDatabase(username: String, email: String, profileImage: UIImage? = nil) async {
        do {
            try await userRepo.saveUserToDatabase(
                username: username,
                email: email,
                profileImage: profileImage
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateUserToDatabase(profileImage: UIImage? = nil, userId: String) async {
        do {
            try await userRepo.updateUserToDatabase(profileImage: profileImage, userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
}
