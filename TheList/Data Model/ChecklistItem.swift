//
//  ChecklistItem.swift
//  TheList
//
//  Created by Richie Flores on 11/19/21.
//

import Foundation
import UserNotifications

class ChecklistItem: Codable {
  var text: String
  var isChecked: Bool
  var shouldRemid: Bool = false
  var dueDate: Date = Date()
  var itemID: Int = -1
  
  init(text: String, isChecked: Bool = false) {
    self.text = text
    self.isChecked = isChecked
    self.itemID = DataModel.nextChecklistItemID()
  }
  
  deinit {
    removeNotification()
  }
  
  func scheduleNotification() {
    removeNotification()
    if shouldRemid && dueDate > Date() {
      let center = UNUserNotificationCenter.current()
      
      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
      
      let content = UNMutableNotificationContent()
      content.title = "Reminder 🚨"
      content.body = self.text
      content.sound = UNNotificationSound.default
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
      
      let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
      center.add(request)
    }
  }
  
  func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["\(self.itemID)"])
  }
  
  func hasNotificationScheduled() -> Bool {
    return (shouldRemid && dueDate > Date()) ? true : false
  }
  
  func configureDate(for dueDate: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: dueDate)
  }
  
  // TODO: Sort Checklist Items list based on Due Date
}
