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
                
                TextField("", text: $authVm.username,
                prompt: Text("Username ").foregroundColor(.gray))
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifier())
                    .foregroundStyle(.primaryText)
                
                TextField("", text: $authVm.email,
                prompt: Text("Email").foregroundColor(.gray))
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifier())
                    .foregroundStyle(.primaryText)
                
                TextField("", text: $authVm.confirmEmail,
                    prompt: Text("Bekräfta Email").foregroundColor(.gray))
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifier())
                    .foregroundStyle(.primaryText)
                
                SecureField("Lösenord", text: $authVm.password,
                    prompt: Text("Lösenord").foregroundColor(.gray))
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                    .foregroundStyle(.primaryText)
                
                SecureField("", text: $authVm.confirmPassword,
                            prompt: Text("Bekräfta Lösenord").foregroundColor(.gray))
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                    .foregroundStyle(.primaryText)
                
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
                            .tint(.primaryText)
                            .modifier(ButtonModifier())
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
