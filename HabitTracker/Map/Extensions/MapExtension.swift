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
