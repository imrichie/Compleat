//
//  AllListsViewController.swift
//  TheList
//
//  Created by Richie Flores on 11/25/21.
//

import UIKit

class AllListsViewController: UITableViewController {
  let cellIdentifier: String = "checklistCell"
  var dataModel: DataModel!
  
 
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.delegate = self
    let index = dataModel.indexOfSelectedChecklist
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel.lists.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let checklist = dataModel.lists[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "checklistCell", for: indexPath)
    configureTableViewCell(for: cell, with: checklist)
    return cell 
  }

  // MARK: - Table View Delegate Methods
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    dataModel.lists.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dataModel.indexOfSelectedChecklist = indexPath.row
    let checklist: Checklist = dataModel.lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
    controller.delegate = self
    controller.checklistToEdit = dataModel.lists[indexPath.row]
    navigationController?.pushViewController(controller, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destination as! ChecklistItemsViewController
      controller.checklist = sender as? Checklist
    } else if segue.identifier == "AddChecklist" {
      let controller = segue.destination as! ListDetailViewController
      controller.delegate = self
    }
  }
  
  func configureTableViewCell(for cell: UITableViewCell, with checklist: Checklist) {
    let count = checklist.countRemaining()
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .detailDisclosureButton
    cell.imageView?.image = UIImage(named: checklist.iconName)
    switch count {
    case 0:
      cell.detailTextLabel!.text = "🥳 All Done!"
    case 1:
      cell.detailTextLabel!.text = "\(count) task remaining"
    default:
      cell.detailTextLabel!.text = "\(count) tasks remaining"
    }
    if checklist.items.count == 0 { cell.detailTextLabel!.text = "(No tasks added)" }
  }
}

extension AllListsViewController: ListDetailViewControllerDelegate {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
    dataModel.lists.append(checklist)
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
}

extension AllListsViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if viewController === self {
      dataModel.indexOfSelectedChecklist = -1
    }
  }
}
