//
//  SettingsView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            VStack {
                
                HStack {
                    Image("settings")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                    
                    Spacer()
                }
                Spacer()
                Button {
                    authViewModel.logOut()
                    dismiss()
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Logga ut")
                    }
                }
                .modifier(ButtonModifier())
            }
        }
        .gradientBackground()
        
    }
}

#Preview {
    SettingsView()
        .environment(AuthViewModel())
}
