//
//  LoginView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State var showRegisterSheet: Bool = false
    
    var body: some View {
        @Bindable var authVm = authViewModel
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                TextField("Email", text: $authVm.email)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifier())
                
                SecureField("Lösenord", text: $authVm.password)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .font(.caption)
                        .foregroundColor(Color.theme.buttonBackground)
                }
                
                Button {
                    authViewModel.login()
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Logga in")
                            .modifier(ButtonModifier())
                    }
                }
                
                Button {
                    showRegisterSheet = true
                        
                } label: {
                    Text("Registrera dig")
                        
                }
                .modifier(ButtonModifierReversedColors())
                
                Spacer()
                Button {
                    authViewModel.continueAsGuest()
                } label: {
                    Text("Fortsätt som gäst")
                        .modifier(OutlineButtonModifier())
                    
                }
                
            }
    
        }
        .sheet(isPresented: $showRegisterSheet) {
            RegisterView()
        }
        .gradientBackground()
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
