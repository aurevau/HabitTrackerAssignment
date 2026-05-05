//
//  Notifications+Extension.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-04.
//

import UserNotifications

extension SettingsView {
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Habit Tracker"
        content.subtitle = "Har du genomför dagens vanor?"
        content.sound = UNNotificationSound.default
        content.userInfo = ["destination": "homeView"]
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 59
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyHabitReminder"])
        
        let request = UNNotificationRequest(identifier: "dailyHabitReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("error sending notification: \(error.localizedDescription)")
                return
            }
            
            if granted {
                print("notification permission granted")
                sendNotification()
            } else {
                print("notification permission denied")
            }
        }
    }
    
    
}
