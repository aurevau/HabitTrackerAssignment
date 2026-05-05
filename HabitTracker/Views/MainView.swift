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
    @Binding var navigateToHome: Bool
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

                VStack(spacing: 0) {
                    Spacer()
                    TabBarView(selectedTab: $selectedTab, action: {
                        showSidebar.toggle()
                    })
                    
                }
                
            }
            .ignoresSafeArea(edges: .bottom)
            .gradientBackground()
            .onChange(of: navigateToHome) { _, newValue in
                if newValue {
                    selectedTab = .home
                    navigateToHome = false
                }
            }
        }
        
        
    }
}

#Preview {
    MainView(navigateToHome: .constant(false))
        .environment(AuthViewModel())
}
