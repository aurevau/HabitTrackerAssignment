//
//  LocationDetailSheet.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-30.
//

import SwiftUI

struct LocationDetailSheet: View {
    let location: Location
    let habit: Habit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let urlString = habitImage,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    phase.image?
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 150)
                        .frame(height: 150)
                        .clipShape(Circle())
                }
            }
            
            Text(location.name)
                .font(.title2)
                .fontWeight(.bold)
            Text(habit.description)
                .font(.caption)
            
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
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
        .presentationBackgroundInteraction(.enabled)
    }
    
    
    
}

