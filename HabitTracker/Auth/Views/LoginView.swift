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
                Image("loggain")
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 60))
                
                TextField("", text: $authVm.email,
                          prompt: Text("Email").foregroundColor(.gray))
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .modifier(TextFieldModifier())
                .foregroundStyle(.primaryText)
                
                SecureField("", text: $authVm.password,
                            prompt: Text("Lösenord").foregroundColor(.gray))
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .foregroundStyle(.primaryText)
                .modifier(TextFieldModifier())
                
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .font(.caption)
                        .foregroundColor(Color.theme.buttonBackground)
                }
                
                Button {
                    Task {
                        await authViewModel.login()
                    }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.primaryText)
                            .modifier(ButtonModifier())
                    } else {
                        Text("Logga in")
                            .modifier(ButtonModifier())
                    }
                }
                
                Spacer()
                
                Button {
                    showRegisterSheet = true
                    
                } label: {
                    Text("Registrera dig")
                    
                }
                .modifier(OutlineButtonModifierReversedColors())
                
                
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
