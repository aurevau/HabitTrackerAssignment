//
//  HomeView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
             
            VStack {
                HStack {
                    Image("hem")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    Spacer()
                }
                .padding(.top)
                Spacer()
                
            }
            
        
    
        }
        
        
    }
}

#Preview {
    HomeView()
}
