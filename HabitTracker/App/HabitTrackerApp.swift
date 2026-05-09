//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-04-27.
//

import SwiftUI
import FirebaseCore
import MapKit

@main
struct HabitTrackerApp: App {
    @State private var locationManager = CLLocationManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    locationManager.requestWhenInUseAuthorization()
                }
        }
    }
}
