//
//  ViewController.swift
//  TheList
//
//  Created by Richie Flores on 11/17/21.
//

import UIKit

class ChecklistItemsViewController: UITableViewController {
  var checklist: Checklist!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = checklist.name
  }
  
  // MARK: - Table View Data Source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.checklist.items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.rowHeight = 60
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let checklistItem = checklist.items[indexPath.row]
    configureImage(for: cell, with: checklistItem)
    configureLabels(for: cell, with: checklistItem)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      checklist.items.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  // MARK: - Table View Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = checklist.items[indexPath.row]
    item.isChecked.toggle()
    if let cell = tableView.cellForRow(at: indexPath) {
      configureImage(for: cell, with: item)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let controller = segue.destination as! EditItemViewController
      controller.delegate = self
    }
    else if segue.identifier == "EditItem" {
      let controller = segue.destination as! EditItemViewController
      controller.delegate = self
      if let path = tableView.indexPath(for: sender as! UITableViewCell) {
        controller.itemToEdit = checklist.items[path.row]
      }
    }
  }
  
  func configureImage(for cell: UITableViewCell, with checklist: ChecklistItem) {
    cell.imageView?.image = checklist.isChecked ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle")
  }
  
  func configureLabels(for cell: UITableViewCell, with item: ChecklistItem) {
    cell.textLabel!.text = item.text
    cell.detailTextLabel!.text = item.hasNotificationScheduled() ? "Due: \(item.configureDate(for: item.dueDate))" : ""
  }
}

extension ChecklistItemsViewController: EditItemViewControllerDelegate {
  func editItemViewControllerDidCancel(_ controller: EditItemViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func editItemViewController(_ controller: EditItemViewController, didFinishAdding item: ChecklistItem) {
    checklist.items.append(item)
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  func editItemViewController(_ controller: EditItemViewController, didFinishEditing item: ChecklistItem) {
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
}
