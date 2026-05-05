//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct AddHabitView: View {
    
    @Environment(HabitLocalViewModel.self) private var habitLocalViewModel
    @Environment(HabitViewModel.self) private var habitViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var habitName = ""
    @State private var habitDescription = ""
    
    var isGuest: Bool {
        authViewModel.authState == .guest
    }
    
    var body: some View {
        
        
        NavigationStack {
            ZStack {
                VStack(spacing: 12) {
                    HStack {
                        Image("vana")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                        Spacer()
                    }
                    .padding()
                    
                    
                    
                    TextField("", text: $habitName,
                              prompt: Text("Titel på din vana").foregroundColor(.gray))
                    
                    .modifier(TextFieldModifier())
                    .foregroundStyle(.primaryText)
                    
                    
                    TextField("", text: $habitDescription,
                              prompt: Text("Beskriv din vana mer").foregroundColor(.gray), axis: .vertical)
                    .modifier(TextFieldModifier())
                    .foregroundStyle(.primaryText)
                    
                    
                    Button {
                        if isGuest {
                            habitLocalViewModel.saveHabit(name: habitName, description: habitDescription)
                        } else {
                            Task {
                                await habitViewModel.saveHabit(userId: authViewModel.currentUserId, habit: Habit(id: UUID().uuidString, name: habitName, description: habitDescription, completedDates: []))
                            }
                            
                            
                        }
                        dismiss()
                    } label: {
                        Text("Spara")
                    }
                    .modifier(ButtonModifier())
                    .disabled(habitName.isEmpty)
                    .padding()
                    
                    Spacer()
                }
            }
            .gradientBackground()
        }
        .toolbar {
            ToolbarItem(placement: .title) {
                
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        AddHabitView()
    }
    
}
