//
//  ContentView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import SwiftUI

struct ContentView: View {
    // Authviewmodel lives here for navigation
    @State private var authViewModel = AuthViewModel()
    @State private var userViewModel = UserViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    switch authViewModel.authState {
                    case .loggedIn:
                        MainView()
                    case .loggedOut:
                        LoginView()
                    case .guest:
                        MainView()
                    }
                }
               
                
                
               
            }
            .gradientBackground()
        }
        .environment(authViewModel)
        .environment(userViewModel)
        
    }
}

#Preview {
    ContentView()
        .environment(AuthViewModel())
}
