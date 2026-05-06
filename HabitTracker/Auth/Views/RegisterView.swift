//
//  RegisterView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import SwiftUI
import PhotosUI

struct RegisterView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(UserViewModel.self) private var userViewModel
    
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var selectedImage: UIImage?
    
    var body: some View {
        
        @Bindable var authVm = authViewModel
        
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                Image("skapakonto")
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 60))
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                        .clipShape(Circle())
                } else {
                    Text("Ingen profilbild vald")
                        .foregroundStyle(.gray)
                        .padding()
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Välj foto")
                        .modifier(ButtonModifier())
                }
                .disabled(selectedImage != nil)
                .onChange(of: selectedItem) { _,  newItem in
                    if let newItem = newItem {
                        Task {
                            if let data = try? await newItem.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                selectedImage = image
                            }
                        }
                    }
                    
                }
                
                
                
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
                    
                    Task {
                        await authViewModel.register()
                        
                        guard authViewModel.registerSuccess else { return }
                        
                        await userViewModel.saveUserToDatabase(username: authViewModel.username, email: authViewModel.email, profileImage: selectedImage, userId: authViewModel.currentUserId)
                    }
                    
                    
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
