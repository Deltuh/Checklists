//
//  ViewController.swift
//  Checklists
//
//  Created by Deividas Sipavicius on 1/20/22.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    var items = [ChecklistItem] ()
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enabling large titles
        navigationItem.largeTitleDisplayMode = .never
        
        // Load items
        loadChecklistItems()
        
        title = checklist.name
    }
    
    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    )   {
        // Give each segue a unique identifier to handle the correct segue
        if segue.identifier == "AddItem" {

            //
            let controller = segue.destination as! ItemDetailViewController
            // 3
            controller.delegate = self
            
    }   else if segue.identifier == "EditItem" {
        let controller = segue.destination as! ItemDetailViewController
        controller.delegate = self
        
        if let indexPath = tableView.indexPath(
            for: sender as! UITableViewCell) {
            controller.itemToEdit = items[indexPath.row]
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
    
    // Sets the checlist item's text on the cell's label
    func configureText (
        for cell: UITableViewCell,
        with item: ChecklistItem
    )   {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    
    func documentsDirectory()-> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
               in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return
        documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        }   catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode(
                    [ChecklistItem].self,
                    from: data)
            }   catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(
        _ tableView: UITableView,                            // parameter 1
        numberOfRowsInSection section: Int                   // parameter 2
    )   -> Int {                                             // return value
        return items.count
    }
    
    override func tableView(
        _ tableView: UITableView,                            // parameter 1
        cellForRowAt indexPath: IndexPath                    // parameter 2
    )   -> UITableViewCell {                                 // return value
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
    
        let item = items[indexPath.row]
        
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
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // One of the table view delegate methods are called when the user taps on a cell
        saveChecklistItems()
    }
        
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    )   {
        // Swipe to delete
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveChecklistItems()
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
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem
    )   {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        saveChecklistItems()
    }
        navigationController?.popViewController(animated: true)
    }
}




