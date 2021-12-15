//
//  DetailViewController.swift
//  TheList
//
//  Created by Richie Flores on 11/17/21.
//

import UIKit

protocol EditItemViewControllerDelegate: AnyObject {
  func editItemViewControllerDidCancel(_ controller: EditItemViewController)
  func editItemViewController(_ controller: EditItemViewController, didFinishAdding item: ChecklistItem)
  func editItemViewController(_ controller: EditItemViewController, didFinishEditing item: ChecklistItem)
}

class EditItemViewController: UITableViewController {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  weak var delegate: EditItemViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let item = itemToEdit {
      self.title = "Edit Item"
      textField.text = item.text
      doneButton.isEnabled = true
      shouldRemindSwitch.isOn = item.shouldRemid
      datePicker.date = item.dueDate
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  // MARK: - Action Methods
  @IBAction func done() {
    if let item = itemToEdit {
      item.text = textField.text!
      item.shouldRemid = shouldRemindSwitch.isOn
      item.dueDate = datePicker.date
      item.scheduleNotification()
      delegate?.editItemViewController(self, didFinishEditing: item)
    } else {
      let newChecklistItem = ChecklistItem(text: textField.text!)
      newChecklistItem.shouldRemid = shouldRemindSwitch.isOn
      newChecklistItem.dueDate = datePicker.date
      newChecklistItem.scheduleNotification()
      self.delegate?.editItemViewController(self, didFinishAdding: newChecklistItem)
    }
  }
  
  @IBAction func cancel() {
    delegate?.editItemViewControllerDidCancel(self)
  }
  
  @IBAction func shouldRemindToggled(_ sender: UISwitch) {
    textField.resignFirstResponder()
    if shouldRemindSwitch.isOn {
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
  }
  
  // MARK: - Table View Data Source
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Next Item"
    case 1:
      return "Notification"
    default:
      return nil
    }
  }
  
  // MARK: - Table View Delegates
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}

extension EditItemViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let oldText = textField.text,
          let stringRange = Range(range, in: oldText) else { return false }
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    
    doneButton.isEnabled = !newText.isEmpty
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneButton.isEnabled = false
    return true
  }
}
