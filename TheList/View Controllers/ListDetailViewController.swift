//
//  ListDetailViewController.swift
//  TheList
//
//  Created by Richie Flores on 11/25/21.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
}

class ListDetailViewController: UITableViewController {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var iconImage: UIImageView!
  
  var delegate: ListDetailViewControllerDelegate?
  var checklistToEdit: Checklist?
  var iconName: String = "Folder"

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let checklist = checklistToEdit {
      self.title = "Edit Checklist"
      textField.text = checklist.name
      doneButton.isEnabled = true
      iconName = checklist.iconName
    }
    iconImage.image = UIImage(named: iconName)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let checklistToEdit = checklistToEdit {
      checklistToEdit.name = textField.text!
      checklistToEdit.iconName = iconName
      delegate?.listDetailViewController(self, didFinishEditing: checklistToEdit)
    } else {
      let newChecklist: Checklist = Checklist(name: textField.text!, icon: iconName)
      delegate?.listDetailViewController(self, didFinishAdding: newChecklist)
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Add New Checklist"
    } else if section == 1 {
      return "Choose Icon Image"
    }
    return nil
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "IconPicker" {
      let controller = segue.destination as! IconPickerViewController
      controller.delegate = self
    }
  }
}

extension ListDetailViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let oldText = textField.text,
          let stringRnage = Range(range, in: oldText) else { return false }
    let newText = oldText.replacingCharacters(in: stringRnage, with: string)
    doneButton.isEnabled = !newText.isEmpty
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneButton.isEnabled = false
    return true
  }
}

extension ListDetailViewController: IconPickerViewControllerDelegate {
  func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
    self.iconName = iconName
    iconImage.image = UIImage(named: iconName)
    navigationController?.popViewController(animated: true)
  }
}
