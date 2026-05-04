//
//  ProfileView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Environment(UserViewModel.self) private var userViewModel
    
    @State private var showLoginSheet: Bool = false
    
  
    
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
                        
                        if let urlString = user.profileImageUrl,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                phase.image?
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .padding()
                                
                            }
                            
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.gray)
                                .padding()
                        }
                        
                        VStack(alignment: .leading) {
            
                            
                                
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
