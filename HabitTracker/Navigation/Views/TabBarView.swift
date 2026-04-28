//
//  TabBarView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct TabBarView: View {
    
    var action: () -> Void
    
    var body: some View {
        ZStack {
            
            // Tab items
            HStack {
                // Expand Button
                Button {
                    action()
                } label: {
                    Image(systemName: "list.bullet")
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                // Navigation Button
                NavigationLink {
                    ProfileView()
                } label: {
                    Image(systemName: "person.circle")
                        .frame(width: 44, height: 44)
                }
            }
            .font(.title2)
            .foregroundColor(.primaryText)
            .padding(EdgeInsets(top: 20, leading: 32, bottom: 24, trailing: 32))
        }

        
        
    }
    
}

#Preview {
    TabBarView(action: {})
}
