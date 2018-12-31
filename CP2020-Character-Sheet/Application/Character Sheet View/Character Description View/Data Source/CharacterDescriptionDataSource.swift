//
//  CharacterDescriptionDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

final class CharacterDescriptionDataSource: EditorValueReciever {    
    private let model: CharacterDescriptionModel
    weak var delegate: CharacterDescriptionDataSourceDelegate?
    
    init(model: CharacterDescriptionModel) {
        self.model = model
        
        NotificationCenter.default.addObserver(self, selector: #selector(nameDidChange(notification:)), name: .nameAndHandleDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(roleDidChange(notification:)), name: .roleDidChange, object: nil)
    }
    
    func valuesFromEditorDidChange(_ values: [String: String]) {
        let newName = values[RoleFieldLabel.name.rawValue]
        let newHandle = values[RoleFieldLabel.handle.rawValue]
        let newRole = values[RoleFieldLabel.handle.rawValue]
        
        if let newName = newName,
            let newHandle = newHandle,
            (newName != model.name || newHandle != model.handle) {
            change(name: newName, handle: newHandle)
        }
        
        if let newRole = newRole, newRole != model.role.rawValue {
            change(role: newRole)
        }
    }
    
    func change(name: String, handle: String) {
        model.set(name: name, handle: handle)
    }
    
    func change(role: String) {
        guard let role = Role(rawValue: role) else {
            return
        }
        
        model.set(role: role)
    }
    
    @objc private func nameDidChange(notification: Notification) {
        fatalError("Need to update static views with the new value")
    }
    
    @objc private func roleDidChange(notification: Notification) {
        fatalError("Need to update static views with the new value")
    }
    
}
