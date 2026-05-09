//
//  Notifications+Extension.swift
//  HabitTracker
//
//  Created by Aurelie Vaudan APP25 on 2026-05-04.
//

import UserNotifications

extension SettingsView {
    
    func sendNotification(date: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = "Habit Tracker"
        content.subtitle = "Har du genomför dagens vanor?"
        content.sound = UNNotificationSound.default
        content.userInfo = ["destination": "homeView"]
        
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.current.component(.hour, from: date)
        dateComponents.minute = Calendar.current.component(.minute, from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyHabitReminder"])
        
        let request = UNNotificationRequest(identifier: "dailyHabitReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func requestNotificationAuthorization(date: Date) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("error sending notification: \(error.localizedDescription)")
                return
            }
            
            if granted {
                print("notification permission granted")
                sendNotification(date: date)
            } else {
                print("notification permission denied")
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyHabitReminder"])
    }
    
    
}
