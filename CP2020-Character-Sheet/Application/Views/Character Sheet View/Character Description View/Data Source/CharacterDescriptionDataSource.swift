//
//  CharacterDescriptionDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CharacterDescriptionDataSource: NSObject, EditorValueReciever {
    
    private let model: CharacterDescriptionModel
    weak var delegate: CharacterDescriptionDataSourceDelegate?
    
    init(model: CharacterDescriptionModel) {
        self.model = model
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(nameDidChange(notification:)), name: .nameAndHandleDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(roleDidChange(notification:)), name: .roleDidChange, object: nil)
    }
    
    // MARK: EditorValueReceiver
    
    func valuesFromEditorDidChange(_ values: [Identifier: AnyHashable], validationCompletion completion: @escaping ValidatedCompletion) {
        let newName = values[RoleFieldLabel.Name.identifier()] as? String
        let newHandle = values[RoleFieldLabel.Handle.identifier()] as? String
        let newRole = values[RoleFieldLabel.CharacterRole.identifier()] as? String
        
        if (newName != model.name || newHandle != model.handle) {
            change(name: newName ?? model.name, handle: newHandle ?? model.handle, validationCompletion: completion)
        }
        
        if let newRole = newRole, newRole != model.role.rawValue {
            change(role: newRole, validationCompletion: completion)
        }
    }
    
    func refreshData() {
        self.delegate?.update(name: self.model.name, handle: self.model.handle)
        self.delegate?.update(role: self.model.role)
    }
    
    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier : AnyHashable]? {
        return nil
    }
    
    /// Changes the values for the name and handle on the model
    ///
    /// - Parameters:
    ///   - name: The new name
    ///   - handle: The new handle
    private func change(name: String, handle: String, validationCompletion completion: @escaping ValidatedCompletion) {
        model.set(name: name, handle: handle, validationCompletion: completion)
    }
    
    /// Changes the value for the role on the model
    ///
    /// - Parameter role: The new role as a string
    /// - Parameter validationCompletion:
    private func change(role: String, validationCompletion completion: @escaping ValidatedCompletion) {
        guard let role = Role(rawValue: role) else {
            return
        }
        
        model.set(role: role, validationCompletion: completion)
    }
    
    @objc private func nameDidChange(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.update(name: self.model.name, handle: self.model.handle)
        }
    }
    
    @objc private func roleDidChange(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.update(role: self.model.role)
        }
    }
    
}
