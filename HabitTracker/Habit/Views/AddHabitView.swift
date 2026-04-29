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
    
    var isGuest: Bool {
        authViewModel.authState == .guest
    }
    
    var body: some View {
        
        
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Image("vana")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                        Spacer()
                    }
                    .padding()
               
                    
                    
                    TextField("", text: $habitName,
                        prompt: Text("Jag vill springa mer").foregroundColor(.gray))
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .modifier(TextFieldModifier())
                        .foregroundStyle(.primaryText)
                    
                    Spacer()
                    
                    Button {
                        if isGuest {
                            habitLocalViewModel.saveHabit(name: habitName)
                        } else {
                            Task {
                                await habitViewModel.saveHabit(userId: authViewModel.currentUserId, habit: Habit(id: UUID().uuidString, name: habitName, completedDates: []))
                            }
                           
                          
                        }
                        dismiss()
                    } label: {
                        Text("Spara")
                    }
                    .modifier(ButtonModifier())
                    .disabled(habitName.isEmpty)
                    .padding()
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
