//
//  HomeView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(HabitLocalViewModel.self) private var habitLocalViewModel
    @Environment(HabitViewModel.self) private var habitViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(UserViewModel.self) private var userViewModel
    
    
    
    
    var body: some View {
        NavigationStack {
            
            VStack {
                HStack() {
                    VStack(alignment: .leading) {
                        Text("HEJ")
                            .foregroundStyle(.primaryText)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if let user = userViewModel.currentUser {
                            Text(user.username.uppercased())
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.primaryText)
                        }
                        
                        if authViewModel.authState == .guest {
                            LocalWeekView(habits: habitLocalViewModel.habits)
                        } else {
                            WeekView(habits: habitViewModel.habits)
                        }
                    }
                    Spacer()
                    
                }
                .padding()
                Spacer()
                
                List {
                    if authViewModel.authState == .guest {
                        ForEach(habitLocalViewModel.habits) {habit in
                            LocalHabitRow(habit: habit)
                        }
                        .onDelete {indexSet in
                            indexSet.forEach {index in
                                habitLocalViewModel.deleteHabit(habitLocalViewModel.habits[index])
                            }
                            
                        }
                    }
                    else {
                        ForEach(habitViewModel.habits) {habit in
                            HabitRow(habit: habit)
                        }
                        .onDelete {indexSet in
                            indexSet.forEach {index in
                                let habit = habitViewModel.habits[index]
                                Task {
                                    await habitViewModel.deleteHabit(userId: authViewModel.currentUserId, habitId: habit.id)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden) 
                
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MapView()
                    } label: {
                        Image(systemName: "mappin")
                    }
                }
            }
            
            
            
            
            
            
            
            
        }
        .task {
            if authViewModel.authState != .guest {
                await habitViewModel.loadHabits(userId: authViewModel.currentUserId)
                
                await userViewModel.getUserDetails(userId: authViewModel.currentUserId)
            }
        }
        .refreshable {
            if authViewModel.authState != .guest {
                await habitViewModel.loadHabits(userId: authViewModel.currentUserId)
            }
        }
        
    }
    
}

#Preview {
    HomeView()
}
