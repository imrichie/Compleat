//
//  DataModel.swift
//  TheList
//
//  Created by Richie Flores on 11/26/21.
//

import Foundation

class DataModel {
  var lists: [Checklist] = []
  
  init() {
    loadChecklist()
    registerDefaults()
    //handleFirstTime()
  }
  
  var indexOfSelectedChecklist: Int {
    get {
      return UserDefaults.standard.integer(forKey: "ChecklistIndex")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
    }
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }

  func dataFilePath() -> URL {
    return getDocumentsDirectory().appendingPathComponent("TheList.plist")
  }

  func saveChecklist() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(lists)
      try data.write(to: dataFilePath(), options: .atomic)
    } catch {
      //print("Error encoding Checklist array: \(error.localizedDescription)")
    }
  }

  func loadChecklist() {
    let path = dataFilePath()
    let decoder = PropertyListDecoder()
    do {
      let data = try Data(contentsOf: path)
      lists = try decoder.decode([Checklist].self, from: data)
    } catch {
      //print("Error loading the contents of the FilePath: \(error.localizedDescription)")
    }
  }
  
  func registerDefaults() {
    let dictionary: [String: Any] = ["ChecklistIndex": -1, "FirstTime": true]
    UserDefaults.standard.register(defaults: dictionary)
  }
  
  func handleFirstTime() {
    let userDefault = UserDefaults.standard
    let firstTime = userDefault.bool(forKey: "FirstTime")
    
    if firstTime {
      let firstChecklist = Checklist(name: "Welcome to the App 🎉")
      firstChecklist.items.append(ChecklistItem(text: "Your first todo-item 📝"))
      lists.append(firstChecklist)
      
      indexOfSelectedChecklist = 0
      userDefault.set(false, forKey: "FirstTime")
    }
  }
  
  class func nextChecklistItemID() -> Int {
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "ChecklistItemID")
    userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
    return itemID
  }
}
