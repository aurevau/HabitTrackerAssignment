//
//  AuthViewModel.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Observation
import Foundation

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
        authState = authRepo.isUserSignedIn() ? .loggedIn : .loggedOut
    }
    
    func login() async {
        guard validateLogin() else {
            return
        }
        
            isLoading = true
            do {
                try await authRepo.login(email: email, password: password)
                authState = .loggedIn
                
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
                authState = .loggedOut
            }
    }
    
    func continueAsGuest() {
        authState = .guest
    }
    
    
    private func validateLogin() -> Bool {
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
        !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        return true
    }
    
    
}
