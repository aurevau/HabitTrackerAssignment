//
//  MapExtension.swift
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
    
    func image(for location: Location, habits: [Habit], authState: AuthState) -> String? {
    
        let calendar = Calendar.current
        return habits
            .flatMap { $0.images }
            .first { calendar.isDate($0.date, inSameDayAs: location.date) }?
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
        let calendar = Calendar.current
        return habit.images
            .first { calendar.isDate($0.date, inSameDayAs: location.date) }?
            .habitImage
    }
}
