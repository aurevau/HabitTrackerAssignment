//
//  HabitRow.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct HabitRow: View {
    
    @Environment(HabitViewModel.self) private var habitViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    
    let habit: Habit
    var body: some View {
        
        
        HStack {
            
            Button {
                Task {
                    await habitViewModel.toggleToday(for: habit, userId: authViewModel.currentUserId)
                    
                    if habit.isCompletedToday {
                        showingCamera = false
                    } else {
                        showingCamera = true
                    }
                }
            } label: {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(habit.isCompletedToday ? .green : .primaryText)
                
            }
            VStack(alignment: .leading){
                Text(habit.name)
                    .fontWeight(.semibold)
                
                Text(habit.description)
                    .font(.caption)
                
            }
            .foregroundColor(.primaryText)
            
            
            Spacer()
            
            Text("🔥 \(habit.currentStreak)")
                .font(.subheadline)
                .foregroundColor(.primaryText)
            
            
            
            
        }
        .padding()
        .gradientCard(isCompleted: habit.isCompletedToday)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .animation(.spring(response: 0.3), value: habit.isCompletedToday)
        .sheet(isPresented: $showingCamera) {
            CameraView(image: $selectedImage)
        }
        .onChange(of: selectedImage) {_, newImage in
            if let image = newImage {
                Task {
                    await habitViewModel.addImageToHabit(userId: authViewModel.currentUserId, habit: habit, image: image)
                }
            }
        }
        
    }
}


