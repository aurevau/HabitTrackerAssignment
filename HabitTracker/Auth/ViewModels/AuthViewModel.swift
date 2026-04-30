//
//  AuthViewModel.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import Observation
import Foundation
import FirebaseAuth

@Observable
class AuthViewModel {
    var authState: AuthState = .guest
    var username = ""
    var email = ""
    var confirmEmail = ""
    var password = ""
    var confirmPassword = ""
    var errorMessage = ""
    
    var isLoading: Bool = false
    var registerSuccess: Bool = false
    
    var currentUserId : String {
        authRepo.getUserId() ?? ""
    }
    
    var userViewModel: UserViewModel?
    
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
            isLoading = false
       
           
    }
    
    func register() async {
        guard validateRegistration() else {
            return
        }
        
            isLoading = true
            do {
                let _ = try await authRepo.register(email: email, password: password, username: username)
                          authState = .loggedIn
                          registerSuccess = true
                
            } catch {
                errorMessage = error.localizedDescription
                registerSuccess = false
            }
            
            isLoading = false
    }
    
    func validateRegistration() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !confirmEmail.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty, !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty, !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Vänligen fyll i alla fält!"
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Lösenordet matchar inte!"
            return false
        }
        
        guard email == confirmEmail else {
            errorMessage = "Email matchar inte"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Vänligen välj ett lösenord med minst 6 tecken."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Vänligen ange en giltig epostadress."
            return false
        }
        return true
    }
    
    func logOut() {
        Task {
            do {
                try authRepo.logOut()
                authState = .loggedOut
            } catch {
                errorMessage = error.localizedDescription
            }
            
        }

    }
    
    func continueAsGuest() {
        authState = .guest
    }
    
    
    private func validateLogin() -> Bool {
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
        !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Vänligen fyll i alla fält!"
            return false
        }
        
        return true
    }
    
    
    
    
}
