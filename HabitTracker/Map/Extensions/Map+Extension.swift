//
//  Map+Extension.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-30.
//

import CoreLocation

extension CLLocationUpdate {
    static func currentLocation() async throws -> CLLocation?{
        for try await update in CLLocationUpdate.liveUpdates() {
            if let location = update.location {
                return location
            }
        }
        return nil 
    }
}


extension MapView {
    
    func image(for location: Location, habits: [Habit]) -> String? {
        guard let habit = habits.first(where: { habit in
            habit.locations.contains { $0.id == location.id }
        }) else { return nil }
        
        return habit.images
            .first { $0.locationId == location.id }?
            .habitImage
    }
    
    func habit(for location: Location, habits: [Habit]) -> Habit? {
        habits.first { habit in
            habit.locations.contains { $0.id == location.id }
        }
    }
}


extension LocationDetailSheet {
    var habitImage: String? {
        return habit.images
            .first { $0.locationId == location.id }?
            .habitImage
    }
}
