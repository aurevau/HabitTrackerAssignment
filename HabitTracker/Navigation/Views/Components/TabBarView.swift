//
//  TabBarView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: TabSelection
    
    @State var showAddHabitSheet: Bool = false
    
    var body: some View {
        ZStack {
            
            Arc()
                .fill(LinearGradient(colors: [Color.theme.cardGradientEnd,
                                    Color.theme.cardGradientMid,
                                              Color.theme.cardGradientStart], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 88)
                .frame(maxWidth: .infinity)
                .overlay {
                    Arc()
                        .stroke(Color.cardBackground, lineWidth: 0.5)
                }
            
            
            
            
            // Tab items
            HStack {
                // Expand Button
                Button {
                    selectedTab = .home
                } label: {
                    Image(systemName: selectedTab == .home ? "house.fill" : "house")
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                ZStack {
                    HeadTabShape()
                        .fill(LinearGradient(colors: [Color.theme.cardGradientEnd,
                                            Color.theme.cardGradientMid,
                                                      Color.theme.cardGradientStart], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 88)
                    
                    Button{
                       showAddHabitSheet = true
                    } label: {
                        Image(systemName:    "plus.app")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
               
                
                // Navigation Button
                Button {
                    selectedTab = .profile
                } label: {
                    Image(systemName: selectedTab == .profile ? "person.fill" : "person.circle")
                        .frame(width: 44, height: 44)
                }
            }
            .font(.title2)
            .foregroundColor(.primaryText)
            .padding(EdgeInsets(top: 20, leading: 32, bottom: 24, trailing: 32))
        }
        .frame(height: 88)
        .sheet(isPresented: $showAddHabitSheet) {
            AddHabitView()
        }

        
        
    }
    
}

#Preview {
    TabBarView(selectedTab: .constant(.home))
}
