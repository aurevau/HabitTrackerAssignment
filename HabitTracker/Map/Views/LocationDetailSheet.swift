//
//  LocationDetailSheet.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-30.
//

import SwiftUI

struct LocationDetailSheet: View {
    let location: Location
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
               
            Text(location.name)
                .font(.title2)
                .fontWeight(.bold)
        
         
         
            Text("Genomförd:")
                .font(.subheadline)
                .fontWeight(.semibold)
            Label(
                location.date.formatted(date: .abbreviated, time: .shortened),
                systemImage: "calendar"
                )
                .foregroundStyle(.secondary)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .presentationDetents([.fraction(0.25)])
        .presentationDragIndicator(.visible)
        .presentationBackgroundInteraction(.enabled) 
    }
}

