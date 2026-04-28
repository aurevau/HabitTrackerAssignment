//
//  MainView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import SwiftUI

struct MainView: View {
    
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var selectedTab: TabSelection = .home
    @State private var showSidebar = false

    var body: some View {
        
        NavigationStack {
            ZStack() {
                
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                            .transition(.move(edge: .leading))
                    case .profile:
                        ProfileView()
                            .transition(.move(edge: .trailing))
                    }
                    
                }
                .animation(.easeInOut, value: selectedTab)
                
                
                //            
                //            VStack {
                //                Spacer()
                //                Text("Hej")
                //                    .font(.largeTitle)
                //                    .foregroundStyle(.primaryText)
                //                Text(authViewModel.authState.rawValue)
                //                    .foregroundStyle(.primaryText)
                //                
                //                
                //                Spacer()
                //                
                //
                //            }
                
                
                VStack(spacing: 0) {
                    Spacer()
                    TabBarView(selectedTab: $selectedTab, action: {
                        showSidebar.toggle()
                    })
                    
                }
                
            }
            .ignoresSafeArea(edges: .bottom)
            .gradientBackground()
        }
        
        
    }
}

#Preview {
    MainView()
        .environment(AuthViewModel())
}
