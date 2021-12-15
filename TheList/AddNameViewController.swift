//
//  AddNameViewController.swift
//  TheList
//
//  Created by Richie Flores on 11/17/21.
//

import UIKit

protocol AddNameViewControllerDelegate: AnyObject {
  func AddNameViewControllerDidCancel(_ controller: DetailViewController)
  func AddNameViewController(_ controller: DetailViewController, didFinishAdding item: Person)
  func AddNameViewController(_ controller: DetailViewController, didFinishEditing item: Person) 
}

class DetailViewController: UITableViewController, UITextFieldDelegate {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  weak var delegate: AddNameViewControllerDelegate?
  
  var nameToEdit: Person?
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let person = nameToEdit {
      self.title = "Edit Name"
      textField.text = person.name
      doneButton.isEnabled = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  // MARK: - Action Methods
  @IBAction func done() {
    if let person = nameToEdit {
      person.name = textField.text!
      delegate?.AddNameViewController(self, didFinishEditing: person)
    } else {
      let newPerson: Person = Person(name: textField.text!)
      let alert = UIAlertController(
        title: "🪦",
        message: "Excellent choice \(newPerson.name), shall be next",
        preferredStyle: .alert)
      
      let action = UIAlertAction(
        title: "Save",
        style: .default) { _ in
          self.delegate?.AddNameViewController(self, didFinishAdding: newPerson)
        }
      alert.addAction(action)
      present(alert, animated: true)
    }
  }
  
  @IBAction func cancel() {
    delegate?.AddNameViewControllerDidCancel(self)
  }
  
  // MARK: - Table View Data Source
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Next Victim"
  }
  
  // MARK: - Table View Delegates
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  // MARK: - TextField Delegate
  // Textfield calls this method when the user edits in the textfield
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let oldText = textField.text,
          let stringRnage = Range(range, in: oldText) else { return false }
    let newText = oldText.replacingCharacters(in: stringRnage, with: string)
    
    doneButton.isEnabled = !newText.isEmpty
    return true
  }
  
  // textField calls this method when the user taps the clear button
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneButton.isEnabled = false
    return true
  }
}
