//
//  MainView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import SwiftUI

struct MainView: View {
    
    @Environment(AuthViewModel.self) private var authViewModel

    var body: some View {
        
        ZStack {
            VStack {
                Spacer()
                Text("Hej")
                    .font(.largeTitle)
                    .foregroundStyle(.primaryText)
                Text(authViewModel.authState.rawValue)
                    .foregroundStyle(.primaryText)
                
                
                Spacer()
                
                Button {
                    authViewModel.logOut()
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Logga ut")
                    }
                }
                .modifier(ButtonModifier())
            }
        }
            .gradientBackground()
        
        
    }
}

#Preview {
    MainView()
        .environment(AuthViewModel())
}
