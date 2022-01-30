//
//  Checklist.swift
//  Checklists
//
//  Created by Deividas Sipavicius on 1/23/22.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var iconName = "No Icon"
    var items = [ChecklistItem]()
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
