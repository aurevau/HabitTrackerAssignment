//
//  AuthViewModel.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Observation

@Observable
class AuthViewModel {
    var authState: AuthState = .guest
    var email = ""
    var password = ""
    var confirmPassword = ""
    var errorMessage = ""
    
    var isLoading: Bool = false
    
    private let authRepo = AuthRepositoryImpl()
    
    init() {
        authState = authRepo.isUserSignedIn() ? .loggedIn : .guest
    }
    
    
}
