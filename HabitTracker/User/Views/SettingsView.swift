//
//  SettingsView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("isNotificationAuhtorized") var isNotificationAuthorized = false
    
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
                
                Toggle(isOn: $isNotificationAuthorized, label: {
                    Text("Slå på Notiser")
                        .foregroundColor(.primaryText)
                    
                })
                
                .onChange(of: isNotificationAuthorized) {_, newValue in
                    if newValue {
                        requestNotificationAuthorization()
                    } else {
                        sendNotification()
                    }
                }
                .padding()
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
        .onReceive(NotificationCenter.default.publisher(for: .navigateToHome)) { _ in
            dismiss()
        }
        
    }
    
}

#Preview {
    SettingsView()
        .environment(AuthViewModel())
}
