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
    
    @State private var uploadProgress: String = ""
    
    var body: some View {
        
        @Bindable var authVm = authViewModel
        ScrollView {
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
                            .scaledToFill()
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
                    .onChange(of: selectedItem) { _, newItem in
                        if let newItem = newItem {
                            Task {
                                guard let data = try? await newItem.loadTransferable(type: Data.self) else { return }
                                let image = await Task.detached(priority: .userInitiated) {
                                    return UIImage(data: data)
                                }.value
                                if let image {
                                    await MainActor.run { selectedImage = image }
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
                        
                        Task { @MainActor in
                            uploadProgress = "Skapar konto..."
                            await authViewModel.register()
                            
                            guard authViewModel.registerSuccess else {
                                uploadProgress = ""
                                return }
                            
                            if selectedImage != nil {
                                uploadProgress = "Laddar upp profilbild"
                            } else {
                                uploadProgress = "Sparar användaren"
                            }
                            
                            Task.detached {
                                await userViewModel.saveUserToDatabase(username: authViewModel.username, email: authViewModel.email, profileImage: selectedImage, userId: authViewModel.currentUserId)
                                
                                uploadProgress = "Färdigställer..."
                                await MainActor.run {
                                    authViewModel.authState = .loggedIn
                                    uploadProgress = ""
                                }
                            }
                            
                        }
                        
                    } label: {
                        if !uploadProgress.isEmpty {
                            VStack {
                                ProgressView()
                                Text(uploadProgress)
                                    .font(.caption)
                                  
                            }
                           
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
}

#Preview {
    RegisterView()
        .environment(AuthViewModel())
}
