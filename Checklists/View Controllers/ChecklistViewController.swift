//
//  ViewController.swift
//  Checklists
//
//  Created by Deividas Sipavicius on 1/20/22.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enabling large titles
        navigationItem.largeTitleDisplayMode = .never
        title = checklist.name
    }
    
    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    )   {
        // Give each segue a unique identifier to handle the correct segue
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
    }   else if segue.identifier == "EditItem" {
        let controller = segue.destination as! ItemDetailViewController
        controller.delegate = self
        
        if let indexPath = tableView.indexPath(
            for: sender as! UITableViewCell) {
            controller.itemToEdit = checklist.items[indexPath.row]
        }
    }        
}
    
    // MARK: - Actions
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    )   {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        }   else {
            label.text = ""
    }
}
    
    // Sets the checklist item's text on the cell's label
    func configureText (
        for cell: UITableViewCell,
        with item: ChecklistItem
    )   {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Table View Data Source
    override func tableView(
        _ tableView: UITableView,                            // parameter 1
        numberOfRowsInSection section: Int                   // parameter 2
    )   -> Int {                                             // return value
        return checklist.items.count
    }
    
    override func tableView(
        _ tableView: UITableView,                            // parameter 1
        cellForRowAt indexPath: IndexPath                    // parameter 2
    )   -> UITableViewCell {                                 // return value
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
    
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(
        _ tableView: UITableView,                            // parameter 1
        didSelectRowAt indexPath: IndexPath                  // parameter 2
    )   {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // One of the table view delegate methods are called when the user taps on a cell
    }
        
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    )   {
        // Swipe to delete
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    // MARK: - Add Item Viewcontroller Delegates
    
    // simply close the Add Item screen
    func itemDetailViewControllerDidCancel(
        _ controller: ItemDetailViewController
    )   {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem
    )   {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        
        
    }
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem
    )   {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        
    }
        navigationController?.popViewController(animated: true)
    }
}




