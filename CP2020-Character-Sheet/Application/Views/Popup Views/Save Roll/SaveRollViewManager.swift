//
//  SaveRollViewManager.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

final class SaveRollViewManager: NSObject, TableViewManaging {
    private var sections = [SaveRollTableSections: [Identifier]]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    func registerCells(for tableView: UITableView) {
        
    }
    
    private enum SaveRollTableSections: Int {
        case Description = 0, Rolls
    }
}
