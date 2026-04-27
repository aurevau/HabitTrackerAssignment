//
//  RegisterView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import SwiftUI

struct RegisterView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    var body: some View {
        
        @Bindable var authVm = authViewModel

        ZStack {
            VStack(spacing: 20) {
                Spacer()
                
                TextField("Username", text: $authVm.username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifier())
                
                TextField("Email", text: $authVm.email)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifier())
                
                TextField("Bekräfta Email", text: $authVm.confirmEmail)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifier())
                
                SecureField("Lösenord", text: $authVm.password)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                SecureField("Bekräfta Lösenord", text: $authVm.confirmPassword)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .font(.caption)
                        .foregroundColor(Color.theme.buttonBackground)
                }
                
                if authViewModel.registerSuccess {
                    Text("Kontot skapat!")
                        .font(.caption)
                        .foregroundColor(.success)
                }
                
                Button {
                    authViewModel.register()
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Skapa konto")
                            .modifier(ButtonModifier())
                    }
                }
                
                Spacer()
           
                
            }
        }
        .onAppear {
            authViewModel.errorMessage = ""
        }
        .onDisappear {
            authViewModel.errorMessage = ""
        }
        .gradientBackground()
    }
}

#Preview {
    RegisterView()
        .environment(AuthViewModel())
}
