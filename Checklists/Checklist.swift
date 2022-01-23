//
//  Checklist.swift
//  Checklists
//
//  Created by Deividas Sipavicius on 1/23/22.
//

import UIKit

class Checklist: NSObject {
    var name = ""
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
