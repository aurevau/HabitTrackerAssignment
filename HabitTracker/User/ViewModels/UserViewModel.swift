//
//  UserViewModel.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Foundation
import Observation

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
}
