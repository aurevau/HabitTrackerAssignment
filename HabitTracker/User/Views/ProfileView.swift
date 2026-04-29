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
                    HStack {
                        Spacer()
                        NavigationLink {
                            SettingsView()
                                .environment(authViewModel)
                        } label: {
                            Image(systemName: "gear")
                                .foregroundColor(.primaryText)
                                .font(.system(size: 24))
                                .padding(.trailing)
                            
                            
                        }
                    }
                    HStack {
                        Image("profil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        
                        Spacer()
                    }
                    
                    
                    
                    Spacer()
                }
                
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
