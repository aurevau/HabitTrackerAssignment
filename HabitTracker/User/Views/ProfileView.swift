//
//  ProfileView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Environment(UserViewModel.self) private var userViewModel
    @Environment(HabitLocalViewModel.self) private var habitLocalViewModel
    
    @State private var showLoginSheet: Bool = false
    
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    
    
    
    var body: some View {
        
        NavigationStack {
            if authViewModel.authState == .guest {
                VStack {
                    Text("Du är inloggad som gäst")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                        .padding()
                    
                    Button {
                        showLoginSheet = true
                    } label: {
                        Text("Skapa konto eller logga in")
                    }
                    .modifier(ButtonModifier())
                }
                .sheet(isPresented: $showLoginSheet) {
                    LoginView()
                }
                
                
                Button {
                    habitLocalViewModel.resetLocalDatabase()
                } label: {
                    Text("Rensa lokal databas")
                }
                .foregroundStyle(.red)
                
                
            } else {
                VStack() {
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
                .task {
                    await userViewModel.getUserDetails(userId: authViewModel.currentUserId)
                }
                HStack {
                    Image("profil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Spacer()
                }
                if let user = userViewModel.currentUser {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else if let urlString = user.profileImageUrl,
                       let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding()
                            
                        } else {
                            ProgressView()
                                .frame(maxWidth: 200)
                                .padding()
                        }
                    }
                        
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.gray)
                            .padding()
                        
                        Text("Ingen profilbild vald")
                            .foregroundStyle(.gray)
                            .padding()
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text(selectedImage == nil ? "Välj profilbild" : "Byt profilbild")
                            .modifier(OutlineButtonModifier())
                            .padding(.top, 12)
                    }
                    .onChange(of: selectedItem) {_, newItem in
                        guard let newItem = newItem else { return }
                        
                            Task { @MainActor in 
                                guard let data = try? await newItem.loadTransferable(type: Data.self),
                                      let image = UIImage(data: data) else { return }
                                
                                selectedImage = image
                            }
                        }
                    
                    if selectedImage != nil {
                        Button {
                            guard let image = selectedImage else { return }

                            Task {
                                isUploading = true
                                await userViewModel.updateUserToDatabase(profileImage: image, userId: authViewModel.currentUserId)
                                
                                if userViewModel.errorMessage.isEmpty {
                                    print("upload succesfull")
                                    await userViewModel.getUserDetails(userId: authViewModel.currentUserId)
                                    selectedItem = nil
                                    selectedImage = nil
                                } else {
                                    print("upload failed")
                                }
                            }
                        } label: {
                            if isUploading {
                                HStack {
                                    ProgressView()
                                        .tint(.primaryText)
                                    Text("Sparar..")
                                        .foregroundColor(.primaryText)
                                }
                            } else {
                                Text("Spara profilbild")
                                    .foregroundColor(.primaryText)
                            }
                        }
                        .padding(.top, 8)
                        .modifier(ButtonModifier())
                        .disabled(isUploading)
                        
                        Button {
                            selectedImage = nil
                            selectedItem = nil
                        } label: {
                            Text("Avbryt")
                                .padding(.top)
                        }
                        .foregroundColor(.red)
                    }
                    
                    if selectedItem == nil {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Medlem sedan:  \(user.formattedJoinedDate)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("Username: \(user.username)")
                                .font(.subheadline)
                                .foregroundColor(.primaryText)
                            
                            Text("Email: \(user.email)")
                                .font(.subheadline)
                                .foregroundColor(.primaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 26)
                        .padding(.top)
                    }
                    
                    
                }
                
                
                
                Spacer()
            }
            
            
            
            
        }
        
    }
}


#Preview {
    NavigationStack {
        ProfileView()
            .environment(AuthViewModel())
    }
    
}
