//
//  MapView.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-30.
//

import SwiftUI
import MapKit
struct MapView: View {
    @Environment(HabitViewModel.self) private var habitViewModel
    @Environment(HabitLocalViewModel.self) private var habitLocalViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    

    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State private var selectedLocation: Location? = nil
    
    private var locations: [Location] {
           if authViewModel.authState == .guest {
               return habitLocalViewModel.habits.flatMap { $0.locations }
           } else {
               return habitViewModel.habits.flatMap { $0.locations }
           }
       }
    var body: some View {
   
            Map(position: $position) {
                UserAnnotation()
                
                ForEach(locations) {location in
                    Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color.theme.cardGradientStart, Color.theme.cardGradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 38, height: 44)
                            
                            if let urlString = image(for: location, habits: habitViewModel.habits),
                               let url = URL(string: urlString) {
                                AsyncImage(url: url) {
                                    phase in
                                    phase.image?
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                }
                            } else {
                                Image(systemName: "mappin")
                                    .foregroundStyle(.primaryText)
                                    .fontWeight(.bold)
                            }
                          
                        }
                        .onTapGesture {
                            selectedLocation = location
                        }
                        
                    }
                }
            }
            .mapControls {
            MapUserLocationButton()
            MapPitchToggle()
        }
        .sheet(item: $selectedLocation) { location in
            if let habit = habit(for: location, habits: habitViewModel.habits) {
                LocationDetailSheet(location: location, habit: habit)
            }
           
        }
        

    }
    
}

#Preview {
    MapView()
}
