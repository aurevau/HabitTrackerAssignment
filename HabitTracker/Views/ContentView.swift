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
    
    
    @State private var habitLocalViewModel = HabitLocalViewModel(inMemory: false)
    @State private var habitViewModel = HabitViewModel()
    
    @State private var hasMigrated = false
    
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    switch authViewModel.authState {
                    case .loggedIn:
                        MainView(navigateToHome: $navigateToHome)
                    case .loggedOut:
                        LoginView()
                    case .guest:
                        MainView(navigateToHome: $navigateToHome)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .navigateToHome)) { _ in
                    navigateToHome = true
                }
               
                
                
               
            }
            .gradientBackground()
        }
        .environment(authViewModel)
        .environment(userViewModel)
        .environment(habitLocalViewModel)
        .environment(habitViewModel)
        .onChange(of: authViewModel.authState) {oldValue, newValue in
            if oldValue == .guest && newValue == .loggedIn && !hasMigrated {
                Task {
                    await migrateHabitsToFirebase()
                    hasMigrated = true
                }
            }
            if newValue == .loggedOut || newValue == .guest {
                hasMigrated = false
            }
        }
        
    }
    
    private func migrateHabitsToFirebase() async {
        let localHabits = habitLocalViewModel.habits
        
        guard !localHabits.isEmpty else {
            return
        }
        
        await habitViewModel.migrateLocalHabits(localHabits: localHabits, userId: authViewModel.currentUserId)
        
        if habitViewModel.errorMessage == nil {
            for habit in localHabits {
                habitLocalViewModel.deleteHabit(habit)
            }
        } else {
            //Migration Failed
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthViewModel())
}
