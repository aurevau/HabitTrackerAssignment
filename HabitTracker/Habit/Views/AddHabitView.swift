//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-28.
//

import SwiftUI

struct AddHabitView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Image("vana")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
            }
            .gradientBackground()
        }
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("Lägg till vana")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
            }
        }
      
    }
}

#Preview {
    NavigationStack {
        AddHabitView()
    }

}
