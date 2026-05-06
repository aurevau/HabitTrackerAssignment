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
    @Environment(UserViewModel.self) private var userViewModel
    
    @State private var notificationDate: Date = Date()
    @AppStorage("isNotificationAuhtorized") var isNotificationAuthorized = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
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
                        requestNotificationAuthorization(date: notificationDate)
                    } else {
                        cancelNotification()
                    }
                }
                .padding()
                
                if isNotificationAuthorized {
                    DatePicker("Välj tid för dina påminnelser", selection: $notificationDate, displayedComponents: [.hourAndMinute])
                        .transition(.blurReplace)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .onChange(of: notificationDate) {_, newDate in
                            sendNotification(date: newDate)
                        }
                }
                Spacer()
            }
            
            
            
            VStack {
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
        .animation(.snappy, value: isNotificationAuthorized)
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
