//
//  AppDelegate.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-04.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let destination = response.notification.request.content.userInfo["destination"] as? String
        
        if destination == "homeView" {
            NotificationCenter.default.post(name: .navigateToHome, object: nil)
        }
    }
}

extension Notification.Name {
    static let navigateToHome = Notification.Name("navigateToHome")
}
