//
//  ProfileView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    
    var body: some View {
        
        NavigationStack {
            
            VStack() {
                HStack {
                    Image("profil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Spacer()
                }
                
                
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                            .environment(authViewModel)
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.primaryText)
                    }
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
