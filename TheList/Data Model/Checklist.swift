//
//  File.swift
//  TheList
//
//  Created by Richie Flores on 11/25/21.
//

import Foundation

class Checklist: Codable {
  var name: String = ""
  var iconName: String = "No Icon"
  var items: [ChecklistItem] = []
  
  init(name: String, icon: String = "Folder") {
    self.name = name
    self.iconName = icon
  }
  
  func countRemaining() -> Int {
    var counter = 0
    for item in items {
      if !item.isChecked {
        counter += 1
      }
    }
    return counter
  }
}
